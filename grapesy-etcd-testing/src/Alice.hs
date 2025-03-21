module Main (main) where

import Control.Concurrent (threadDelay)
import Control.Monad (replicateM_)
import Data.ByteString (ByteString)
import Network.GRPC.Client (Address (Address), Connection, Server (ServerInsecure), withConnection)
import Network.GRPC.Common (def)
import Network.GRPC.Common.Protobuf (defMessage, (&), (.~))
import Network.GRPC.Etcd.Client.Simple qualified as Etcd
import System.Exit (exitSuccess)

{-------------------------------------------------------------------------------
  Call some methods of the Etcd service
-------------------------------------------------------------------------------}

range :: Connection -> IO ()
range conn = do
    let req = defMessage & #key .~ "foo"
    resp <- Etcd.range conn req
    print resp

put :: ByteString -> Connection -> IO ()
put value conn = do
    let req =
            defMessage
                & #key
                .~ "foo"
                & #value
                .~ value
    resp <- Etcd.put conn req
    print resp

watch :: Connection -> IO ()
watch conn = do
    let req = defMessage & #createRequest .~ (defMessage & #key .~ "foo")
    Etcd.watch conn [req] (const exitSuccess)

subroutine :: Connection -> IO ()
subroutine conn = do
    _ <- range conn
    replicateM_ 1_000 $ do
        put "sneaky" conn
        threadDelay 10_000
    _ <- put "alice" conn
    watch conn

main :: IO ()
main = withConnection def server subroutine
  where
    server :: Server
    server = ServerInsecure $ Address "127.0.0.1" 2379 Nothing
