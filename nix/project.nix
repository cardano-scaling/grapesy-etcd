{ repoRoot, inputs, pkgs, system, lib }:

let

  cabalProject' = pkgs.haskell-nix.cabalProject' ({ pkgs, config, ... }:
    let
      isCross = pkgs.stdenv.hostPlatform != pkgs.stdenv.buildPlatform;
    in
    {
      src = ../.;

      shell.withHoogle = false;
      shell.packages = p: [p.grapesy-etcd p.proto-lens-protoc];

      inputMap = {
        "https://chap.intersectmbo.org/" = inputs.iogx.inputs.CHaP;
      };

      name = "grapesy-etcd";

      compiler-nix-name = lib.mkDefault "ghc982";

      modules = [
        ({ config, ... }: {
          packages = {
            proto-lens-protobuf-types.components.library.build-tools =
              [ pkgs.protobuf ];
            grapesy-etcd.components.library.build-tools =
              [ pkgs.protobuf ];
          };
        })
      ];
    });

  cabalProject = cabalProject'.appendOverlays [ ];

  project = lib.iogx.mkHaskellProject {
    inherit cabalProject;

    shellArgs = repoRoot.nix.shell;


  };

in
project
