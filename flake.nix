{
  description = "grapesy-etcd: gRPC haskell client for etcd.io";

  inputs = {
    CHaP = {
      url = "github:input-output-hk/cardano-haskell-packages?ref=repo";
      flake = false;
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    horizon-advance.url = "git+https://gitlab.horizon-haskell.net/package-sets/horizon-advance?ref=lts/ghc-9.10.x";
    lint-utils = {
      url = "github:homotopic/lint-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = inputs@{ self, ... }: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [ "x86_64-darwin" "x86_64-linux" "aarch64-darwin" "aarch64-linux" ];
    perSystem = { config, pkgs, system, ... }:
      with pkgs.haskell.lib.compose;
      let

        overlay = final: prev: {
          grapesy-etcd = final.callCabal2nix "grapesy-etcd" ./grapesy-etcd { };
          grapesy-etcd-testing = final.callCabal2nix "grapesy-etcd-testing" ./grapesy-etcd-testing { };
          proto-lens-etcd = addSetupDepends [ pkgs.protobuf ] (final.callCabal2nix "proto-lens-etcd" ./proto-lens-etcd { });
        };

        legacyPackages = inputs.horizon-advance.legacyPackages.${system}.extend overlay;

      in
      {

        checks = let lu = inputs.lint-utils.linters.${system}; in {
          hlint = lu.hlint { src = self; hlint = pkgs.hlint; };
          cabal-fmt = lu.cabal-fmt { src = self; };
          fourmolu = lu.fourmolu { src = self; opts = ""; };
          nixpkgs-fmt = lu.nixpkgs-fmt { src = self; };
          vm-test = import ./nix/test-system.nix {
            inherit (inputs) nixpkgs;
            inherit pkgs system; haskellPackages = legacyPackages;
          };
        };


        devShells.default = legacyPackages.shellFor {
          packages = p: [ p.grapesy-etcd p.grapesy-etcd-testing p.proto-lens-etcd ];
          buildInputs = [
            legacyPackages.cabal-install
            legacyPackages.proto-lens-protoc
            pkgs.haskellPackages.cabal-fmt
            pkgs.haskellPackages.stylish-haskell
            pkgs.hlint
            pkgs.nixpkgs-fmt
            pkgs.protobuf
            pkgs.treefmt
          ];
        };

        packages.default = legacyPackages.grapesy-etcd;

      };
  };

  nixConfig = {
    extra-substituters = [ "https://cache.iog.io" "https://horizon.cachix.org" ];
    extra-trusted-public-keys =
      [
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
        "horizon.cachix.org-1:MeEEDRhRZTgv/FFGCv3479/dmJDfJ82G6kfUDxMSAw0="
      ];
    allow-import-from-derivation = true;
  };
}
