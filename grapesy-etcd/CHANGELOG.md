# ChangeLog for grapesy-etc

## 0.3.0

* Move proto-lens generation to a separate library `proto-lens-etcd`.
* Change main module name to `Network.GRPC.Etcd`.
* Add metadata instances for `Auth`, `Cluster`, `Lease` and `Maintenance`.

## 0.2.0

* Add `Network.GRPC.Etcd.Client.Simple` with functions for `put`, `range` and `get`.

## 0.1.0

* Initial version of grapesy-etc client. Contains full bindings to the etcdv3 spec as defined in
rpc.proto.
