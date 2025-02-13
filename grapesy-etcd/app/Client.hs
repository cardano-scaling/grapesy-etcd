module Client (main) where

import Control.Concurrent
import Control.Monad
import Data.Int
import Data.Text (Text)
import System.Random

import Network.GRPC.Client
import Network.GRPC.Client.StreamType.IO
import Network.GRPC.Common
import Network.GRPC.Common.NextElem qualified as NextElem
import Network.GRPC.Common.Protobuf

import Proto.API.Etcd

{-------------------------------------------------------------------------------
  Call some methods of the Etcd service
-------------------------------------------------------------------------------}

range :: Connection -> IO ()
range conn = do
    let req = defMessage
                & #key  .~  "foo"
    resp <- nonStreaming conn (rpc @(Protobuf KV "range")) req
    print resp

put :: Connection -> IO ()
put conn = do
    let req = defMessage
                & #key  .~  "foo"
    resp <- nonStreaming conn (rpc @(Protobuf KV "put")) req
    print resp


main :: IO ()
main =
    withConnection def server $ \conn -> do
      putStrLn "-------------- Range --------------"
      range conn
      put conn

  where
    server :: Server
    server = ServerInsecure $ Address "127.0.0.1" 2379 Nothing
--}
