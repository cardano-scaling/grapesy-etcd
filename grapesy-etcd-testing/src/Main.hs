module Main (main) where

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

put :: Connection -> IO ()
put conn = do
    let req = defMessage & #key .~ "foo"
    resp <- Etcd.put conn req
    print resp

watch :: Connection -> IO ()
watch conn = do
    let req = defMessage & #createRequest .~ (defMessage & #key .~ "foo")
    Etcd.watch conn [req] (const exitSuccess)

main :: IO ()
main =
    withConnection def server $ do
        _ <- range
        _ <- put
        watch
  where
    server :: Server
    server = ServerInsecure $ Address "127.0.0.1" 2379 Nothing
