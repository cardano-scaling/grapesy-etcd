{
  description = "grapesy-etcd: gRPC haskell client for etcd.io";

  inputs = {
    etcd = {
      url = "github:etcd-io/etcd/v3.6.2";
      flake = false;
    };
    files.url = "github:mightyiam/files";
    gogoproto = {
      url = "github:cosmos/gogoproto/v1.7.0";
      flake = false;
    };
    googleapis = {
      url = "github:googleapis/googleapis";
      flake = false;
    };
    grpc-gateway = {
      url = "github:grpc-ecosystem/grpc-gateway/v2.27.1";
      flake = false;
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    horizon-advance.url = "git+https://gitlab.horizon-haskell.net/package-sets/horizon-advance?ref=lts/ghc-9.10.x";
    hydra-coding-standards.url = "github:cardano-scaling/hydra-coding-standards/0.7.0";
    import-tree.url = "github:vic/import-tree";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./nix);

}
