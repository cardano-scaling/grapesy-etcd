{
  description = "grapesy-etcd: gRPC haskell client for etcd.io";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    horizon-advance.url = "git+https://gitlab.horizon-haskell.net/package-sets/horizon-platform?ref=lts/ghc-9.10.x";
    lint-utils = {
      url = "github:homotopic/lint-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = inputs@{ self, ... }: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [ "x86_64-darwin" "x86_64-linux" "aarch64-darwin" "aarch64-linux" ];
    perSystem = { config, pkgs, system, ... }:
      with pkgs.haskell.lib.compose;
      let

        overlay = final: prev: {
          etcd-embed = addSetupDepends [ pkgs.etcd ] (final.callCabal2nix "etcd-embed" ./etcd-embed { });
          grapesy-etcd = final.callCabal2nix "grapesy-etcd" ./grapesy-etcd { };
          grapesy-etcd-testing = final.callCabal2nix "grapesy-etcd-testing" ./grapesy-etcd-testing { };
          proto-lens-etcd = addSetupDepends [ pkgs.protobuf ] (final.callCabal2nix "proto-lens-etcd" ./proto-lens-etcd { });
          which-embed = final.callCabal2nix "which-embed" ./which-embed { };
          which = final.callHackage "which" "0.2.0.3" { };
        };

        legacyPackages = inputs.horizon-advance.legacyPackages.${system}.extend overlay;

      in
      rec {

        checks = let lu = inputs.lint-utils.linters.${system}; in {
          hlint = lu.hlint { src = self; hlint = pkgs.hlint; };
          treefmt = lu.treefmt {
            src = self;
            buildInputs = [
              pkgs.haskellPackages.cabal-fmt
              pkgs.haskellPackages.fourmolu
              pkgs.nixpkgs-fmt
            ];
            treefmt = pkgs.treefmt;
          };
          vm-test = import ./nix/test-system.nix {
            inherit (inputs) nixpkgs;
            inherit self pkgs system; haskellPackages = legacyPackages;
          };
          werror-etcd-embed = lu.werror { pkg = packages.etcd-embed; };
          werror-grapesy-etcd = lu.werror { pkg = packages.grapesy-etcd; };
          werror-grapesy-etcd-testing = lu.werror { pkg = packages.grapesy-etcd-testing; };
          werror-proto-lens-etcd = lu.werror { pkg = packages.proto-lens-etcd; };
          werror-which-embed = lu.werror { pkg = packages.which-embed; };
        };


        devShells.default = legacyPackages.shellFor {
          packages = p: [ p.grapesy-etcd p.grapesy-etcd-testing p.proto-lens-etcd ];
          buildInputs = [
            legacyPackages.cabal-install
            legacyPackages.proto-lens-protoc
            pkgs.haskellPackages.cabal-fmt
            pkgs.haskellPackages.fourmolu
            pkgs.etcd
            pkgs.hlint
            pkgs.nixpkgs-fmt
            pkgs.protobuf
            pkgs.treefmt
          ];
        };

        packages = {
          inherit (legacyPackages)
            etcd-embed
            grapesy-etcd
            grapesy-etcd-testing
            proto-lens-etcd
            which-embed;
        };

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
