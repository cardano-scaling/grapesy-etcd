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
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = inputs@{ self, ... }: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [ "x86_64-linux" "aarch64-linux" ];
    perSystem = { config, pkgs, system, ... }:
      with pkgs.haskell.lib.compose;
      let

        overlay = final: prev: {
          grapesy-etcd = dontCheck (addSetupDepends [pkgs.protobuf] (final.callCabal2nix "grapesy-etcd" ./grapesy-etcd { }));
        };

        legacyPackages = inputs.horizon-advance.legacyPackages.${system}.extend overlay;
      in
      {

        checks = let lu = inputs.lint-utils.linters.${system}; in {
          hlint = lu.hlint { src = self; hlint = pkgs.hlint; };
          treefmt = lu.treefmt {
            src = self;
            buildInputs = [
              pkgs.haskellPackages.cabal-fmt
              pkgs.nixpkgs-fmt
              pkgs.fourmolu
            ];
            treefmt = pkgs.treefmt;
          };
        };


        devShells.default = legacyPackages.grapesy-etcd.env.overrideAttrs (attrs: {
          buildInputs = attrs.buildInputs ++ [
            pkgs.haskellPackages.cabal-fmt
            legacyPackages.cabal-install
            pkgs.fourmolu
            pkgs.hlint
            legacyPackages.proto-lens-protoc
            pkgs.nixpkgs-fmt
            pkgs.protobuf
            pkgs.treefmt
          ];
        });

        packages.default = legacyPackages.grapesy-etcd;

      };
  };

  nixConfig = {
    extra-substituters = [ "https://cache.iog.io" ];
    extra-trusted-public-keys =
      [ "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" ];
    allow-import-from-derivation = true;
  };
}
