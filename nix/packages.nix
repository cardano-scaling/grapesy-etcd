{ inputs, self, ... }: {
  perSystem = { pkgs, lib, system, ... }:
    with pkgs.haskell.lib.compose;
    let

      overlay = final: _prev: {
        enclosed-exceptions = final.callHackage "enclosed-exceptions" "1.0.3" { };
        etcd-embed = addSetupDepends [ pkgs.etcd ] (final.callCabal2nix "etcd-embed" (lib.cleanSource "${self}/etcd-embed") { });
        grapesy-etcd = final.callCabal2nix "grapesy-etcd" (lib.cleanSource "${self}/grapesy-etcd") { };
        grapesy-etcd-testing = final.callCabal2nix "grapesy-etcd-testing" (lib.cleanSource "${self}/grapesy-etcd-testing") { };
        hspec-contrib = final.callHackage "hspec-contrib" "0.5.2" { };
        proto-lens-etcd = addSetupDepends [ pkgs.protobuf ] (final.callCabal2nix "proto-lens-etcd" (lib.cleanSource "${self}/proto-lens-etcd") { });
        shelly = dontCheck (final.callHackage "shelly" "1.12.1" { });
        which-embed = addSetupDepends [ pkgs.which ] (final.callCabal2nix "which-embed" (lib.cleanSource "${self}/which-embed") { });
        which = final.callHackage "which" "0.2.0.3" { };
      };

      legacyPackages = inputs.horizon-advance.legacyPackages.${system}.extend overlay;

    in
    rec {

      devShells.default = legacyPackages.shellFor {
        packages = p: [
          p.etcd-embed
          p.grapesy-etcd
          p.grapesy-etcd-testing
          p.proto-lens-etcd
          p.which-embed
        ];
        buildInputs = [
          legacyPackages.cabal-install
          legacyPackages.proto-lens-protoc
          pkgs.etcd
          pkgs.haskellPackages.cabal-fmt
          pkgs.haskellPackages.fourmolu
          pkgs.hlint
          pkgs.nixpkgs-fmt
          pkgs.protobuf
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

}
