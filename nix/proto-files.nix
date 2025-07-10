{ inputs, ... }: {
  perSystem = { pkgs, ... }:
    let
      files = [
        {
          source = "${inputs.etcd}/api/authpb/auth.proto";
          target = "proto-lens-etcd/proto/etcd/api/authpb/auth.proto";
        }
        {
          source = "${inputs.etcd}/api/etcdserverpb/rpc.proto";
          target = "proto-lens-etcd/proto/etcd/api/etcdserverpb/rpc.proto";
        }
        {
          source = "${inputs.etcd}/api/mvccpb/kv.proto";
          target = "proto-lens-etcd/proto/etcd/api/mvccpb/kv.proto";
        }
        {
          source = "${inputs.etcd}/api/versionpb/version.proto";
          target = "proto-lens-etcd/proto/etcd/api/versionpb/version.proto";
        }
        {
          source = "${inputs.gogoproto}/gogoproto/gogo.proto";
          target = "proto-lens-etcd/proto/gogoproto/gogo.proto";
        }
        {
          source = "${inputs.grpc-gateway}/protoc-gen-openapiv2/options/annotations.proto";
          target = "proto-lens-etcd/proto/protoc-gen-openapiv2/options/annotations.proto";
        }
        {
          source = "${inputs.grpc-gateway}/protoc-gen-openapiv2/options/openapiv2.proto";
          target = "proto-lens-etcd/proto/protoc-gen-openapiv2/options/openapiv2.proto";
        }
      ];
    in
    {
      files.files = map
        (x:
          {
            path_ = x.target;
            drv = pkgs.runCommand "file-derivation" { } ''
              cp "${x.source}" $out
            '';
          })
        files;
    };
}
