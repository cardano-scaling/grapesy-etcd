{ inputs, self, ... }: {
  perSystem = { pkgs, system, ... }:
    with pkgs.haskell.lib.compose;
    let

      overlay = final: _prev: {
        grapesy-etcd = final.callCabal2nix "grapesy-etcd" "${self}/grapesy-etcd" { };
        grapesy-etcd-testing = final.callCabal2nix "grapesy-etcd-testing" "${self}/grapesy-etcd-testing" { };
        proto-lens-etcd = addSetupDepends [ pkgs.protobuf ] (final.callCabal2nix "proto-lens-etcd" "${self}/proto-lens-etcd" { });
      };

      legacyPackages = inputs.horizon-advance.legacyPackages.${system}.extend overlay;

    in
    rec {

      devShells.default = legacyPackages.shellFor {
        packages = p: [ p.grapesy-etcd p.grapesy-etcd-testing p.proto-lens-etcd ];
        buildInputs = [
          legacyPackages.cabal-install
          legacyPackages.proto-lens-protoc
          pkgs.haskellPackages.cabal-fmt
          pkgs.haskellPackages.fourmolu
          pkgs.hlint
          pkgs.nixpkgs-fmt
          pkgs.protobuf
        ];
      };

      packages = {
        inherit (legacyPackages)
          grapesy-etcd
          grapesy-etcd-testing
          proto-lens-etcd;
      };

    };

}
