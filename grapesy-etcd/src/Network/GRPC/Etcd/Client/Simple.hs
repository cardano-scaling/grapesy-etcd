{-# OPTIONS_GHC -Wno-orphans #-}

module Network.GRPC.Etcd.Client.Simple (
  put
 , watch
) where

import Network.GRPC.Common.Protobuf

import Proto.API.Etcd
import Network.GRPC.Client.StreamType.IO
import Network.GRPC.Common.NextElem qualified as NextElem
import Network.GRPC.Client
import Control.Monad.IO.Class
import Control.Monad.Catch

put :: MonadIO m => MonadMask m => Connection -> Proto PutRequest -> m (Proto PutResponse)
put conn = nonStreaming conn (rpc @(Protobuf KV "put"))

watch :: MonadIO m => MonadMask m => Connection -> [Proto WatchRequest] -> (Proto WatchResponse -> m ()) -> m ()
watch conn reqs resp = biDiStreaming conn (rpc @(Protobuf Watch "watch")) $ \send recv -> do
  NextElem.forM_ reqs send
  NextElem.whileNext_ recv resp
