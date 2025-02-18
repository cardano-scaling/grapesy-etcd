{-# OPTIONS_GHC -Wno-orphans #-}

module Proto.API.Etcd (
    module Proto.Etcd.Api.Etcdserverpb.Rpc,
) where

import Network.GRPC.Common
import Network.GRPC.Common.Protobuf
import Proto.Etcd.Api.Etcdserverpb.Rpc

{-------------------------------------------------------------------------------
  Metadata
-------------------------------------------------------------------------------}

type instance RequestMetadata (Protobuf KV meth) = NoMetadata
type instance ResponseInitialMetadata (Protobuf KV meth) = NoMetadata
type instance ResponseTrailingMetadata (Protobuf KV meth) = NoMetadata

type instance RequestMetadata (Protobuf Watch meth) = NoMetadata
type instance ResponseInitialMetadata (Protobuf Watch meth) = NoMetadata
type instance ResponseTrailingMetadata (Protobuf Watch meth) = NoMetadata
