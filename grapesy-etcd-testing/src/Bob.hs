module Main (main) where

import Control.Monad (forM_, when)
import Network.GRPC.Client (Address (Address), Connection, Server (ServerInsecure), withConnection)
import Network.GRPC.Common (def)
import Network.GRPC.Common.Protobuf (defMessage, (&), (.~), (^.))
import Network.GRPC.Etcd.Client.Simple qualified as Etcd
import System.Exit (exitFailure, exitSuccess)

{-------------------------------------------------------------------------------
  Call some methods of the Etcd service
-------------------------------------------------------------------------------}

range :: Connection -> IO ()
range conn = do
  let req =
        defMessage
          & #key
          .~ "foo"
  res <- Etcd.range conn req
  print res
  let kvs = res ^. #kvs
  when (null kvs) exitFailure
  forM_ (res ^. #kvs) $ \kv -> do
    let value = kv ^. #value
    if value == "alice" then exitSuccess else exitFailure

main :: IO ()
main = withConnection def server range
  where
    server :: Server
    server = ServerInsecure $ Address "127.0.0.1" 2379 Nothing
