module Main (main) where

import Control.Monad (when)
import Network.GRPC.Client (Address (Address), Connection, Server (ServerInsecure), withConnection)
import Network.GRPC.Common (def)
import Network.GRPC.Common.Protobuf (defMessage, (&), (.~), (^.))
import Network.GRPC.Etcd.Client.Simple qualified as Etcd
import System.Exit (exitSuccess)

{-------------------------------------------------------------------------------
  Call some methods of the Etcd service
-------------------------------------------------------------------------------}

watch :: Connection -> IO ()
watch conn = do
    let req =
            defMessage
                & #createRequest
                .~ ( defMessage
                        & #key
                        .~ "foo"
                        & #startRevision
                        .~ 1
                   )
    Etcd.watch conn [req] $ \res -> do
        print res
        let events = res ^. #events
        let xs = flip map events $ \x -> x ^. #kv . #value
        when ("alice" `elem` xs) exitSuccess

main :: IO ()
main = withConnection def server watch
  where
    server :: Server
    server = ServerInsecure $ Address "127.0.0.1" 2379 Nothing
