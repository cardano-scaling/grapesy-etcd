{-# OPTIONS_GHC -Wno-orphans #-}

module Network.GRPC.Etcd.Client.Simple (
    leaseGrant,
    leaseKeepAlive,
    put,
    range,
    watch,
) where

import Control.Monad.Catch (MonadMask)
import Control.Monad.IO.Class (MonadIO)
import Network.GRPC.Client (Connection, rpc)
import Network.GRPC.Client.StreamType.IO (biDiStreaming, nonStreaming)
import Network.GRPC.Common.NextElem qualified as NextElem
import Network.GRPC.Common.Protobuf (Proto, Protobuf)
import Network.GRPC.Etcd (
    KV,
    Lease,
    LeaseGrantRequest,
    LeaseGrantResponse,
    LeaseKeepAliveRequest,
    LeaseKeepAliveResponse,
    PutRequest,
    PutResponse,
    RangeRequest,
    RangeResponse,
    Watch,
    WatchRequest,
    WatchResponse,
 )

leaseGrant ::
    (MonadIO m) =>
    (MonadMask m) =>
    Connection ->
    Proto LeaseGrantRequest ->
    m (Proto LeaseGrantResponse)
leaseGrant conn = nonStreaming conn (rpc @(Protobuf Lease "leaseGrant"))

leaseKeepAlive ::
    (MonadIO m) =>
    (MonadMask m) =>
    Connection ->
    [Proto LeaseKeepAliveRequest] ->
    (Proto LeaseKeepAliveResponse -> m ()) ->
    m ()
leaseKeepAlive conn reqs resp = biDiStreaming conn (rpc @(Protobuf Lease "leaseKeepAlive")) $ \send recv -> do
    NextElem.forM_ reqs send
    NextElem.whileNext_ recv resp

put ::
    (MonadIO m) =>
    (MonadMask m) =>
    Connection ->
    Proto PutRequest ->
    m (Proto PutResponse)
put conn = nonStreaming conn (rpc @(Protobuf KV "put"))

range ::
    (MonadIO m) =>
    (MonadMask m) =>
    Connection ->
    Proto RangeRequest ->
    m (Proto RangeResponse)
range conn = nonStreaming conn (rpc @(Protobuf KV "range"))

watch ::
    (MonadIO m) =>
    (MonadMask m) =>
    Connection ->
    [Proto WatchRequest] ->
    (Proto WatchResponse -> m ()) ->
    m ()
watch conn reqs resp = biDiStreaming conn (rpc @(Protobuf Watch "watch")) $ \send recv -> do
    NextElem.forM_ reqs send
    NextElem.whileNext_ recv resp
