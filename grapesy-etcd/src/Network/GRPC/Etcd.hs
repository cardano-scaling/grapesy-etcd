{-# OPTIONS_GHC -Wno-missing-import-lists #-}
{-# OPTIONS_GHC -Wno-orphans #-}

module Network.GRPC.Etcd
  ( module Proto.API.Etcd,
  )
where

import Network.GRPC.Common
  ( NoMetadata,
    RequestMetadata,
    ResponseInitialMetadata,
    ResponseTrailingMetadata,
  )
import Network.GRPC.Common.Protobuf (Protobuf)
import Proto.API.Etcd

{-------------------------------------------------------------------------------
  Metadata
-------------------------------------------------------------------------------}

type instance RequestMetadata (Protobuf Auth meth) = NoMetadata

type instance ResponseInitialMetadata (Protobuf Auth meth) = NoMetadata

type instance ResponseTrailingMetadata (Protobuf Auth meth) = NoMetadata

type instance RequestMetadata (Protobuf Cluster meth) = NoMetadata

type instance ResponseInitialMetadata (Protobuf Cluster meth) = NoMetadata

type instance ResponseTrailingMetadata (Protobuf Cluster meth) = NoMetadata

type instance RequestMetadata (Protobuf KV meth) = NoMetadata

type instance ResponseInitialMetadata (Protobuf KV meth) = NoMetadata

type instance ResponseTrailingMetadata (Protobuf KV meth) = NoMetadata

type instance RequestMetadata (Protobuf Lease meth) = NoMetadata

type instance ResponseInitialMetadata (Protobuf Lease meth) = NoMetadata

type instance ResponseTrailingMetadata (Protobuf Lease meth) = NoMetadata

type instance RequestMetadata (Protobuf Maintenance meth) = NoMetadata

type instance ResponseInitialMetadata (Protobuf Maintenance meth) = NoMetadata

type instance ResponseTrailingMetadata (Protobuf Maintenance meth) = NoMetadata

type instance RequestMetadata (Protobuf Watch meth) = NoMetadata

type instance ResponseInitialMetadata (Protobuf Watch meth) = NoMetadata

type instance ResponseTrailingMetadata (Protobuf Watch meth) = NoMetadata
