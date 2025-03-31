module Data.WhichEmbed where

import Control.Exception (catch)
import Control.Monad.Catch (MonadMask)
import Control.Monad.IO.Class (MonadIO, liftIO)
import Data.Bits ((.|.))
import Data.ByteString qualified as BS
import Data.FileEmbed (embedFile)
import Language.Haskell.TH (Exp (LitE), Lit (StringL), Q, runIO)
import Path (Abs, File, Path, parseRelFile, toFilePath, (</>))
import Path.IO (withSystemTempDir)
import System.Environment (getEnv)
import System.Posix.Files (ownerExecuteMode, ownerReadMode, ownerWriteMode, setFileMode)
import System.Which (staticWhich)

embedWhich :: FilePath -> Q Exp
embedWhich cmd = do
    -- Log entry to confirm function is running
    runIO (putStrLn $ "Debug: Entering embedWhich with cmd = " ++ cmd)

    -- Log the PATH
    path <- runIO (getEnv "PATH" `catch` (\(_ :: IOError) -> return "PATH not set"))
    runIO (putStrLn $ "Debug: PATH during compilation = " ++ path)

    -- Call staticWhich and log its result
    x <- staticWhich cmd
    runIO (putStrLn $ "Debug: staticWhich " ++ cmd ++ " returned: " ++ show x)

    -- Handle the result
    case x of
        LitE (StringL z) -> do
            runIO (putStrLn $ "Debug: Embedding file at: " ++ z)
            embedFile z
        _ -> do
            runIO (putStrLn $ "Debug: staticWhich failed, returned non-literal: " ++ show x)
            error $ "staticWhich did not return a string literal, got: " ++ show x

withEmbeddedExe ::
    (MonadIO m) =>
    (MonadMask m) =>
    -- | A name to use for the temp directory.
    String ->
    -- | The embedded bytes to use as an executable.
    BS.ByteString ->
    -- | A callback using the path to the executable.
    (Path Abs File -> m a) ->
    m a
withEmbeddedExe name bytes f = do
    withSystemTempDir name $ \fp -> do
        x <- parseRelFile name
        let exe = fp </> x
        liftIO $ do
            BS.writeFile (toFilePath exe) bytes
            setFileMode (toFilePath exe) (ownerReadMode .|. ownerWriteMode .|. ownerExecuteMode)
        f exe
