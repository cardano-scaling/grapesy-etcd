{ nixpkgs, pkgs, system, haskellPackages, ... }:
let
  makeTest = (import (nixpkgs + "/nixos/lib/testing-python.nix") { inherit system; }).makeTest;

  grapesy-etcd-test-vm = makeTest {
    name = "grapesy-etcd-test-vm";
    nodes = {
      etcdSystem = { ... }: {
        environment.systemPackages = [ pkgs.etcd ];
        services.etcd.enable = true;
        networking.firewall.enable = false;
        virtualisation = {
          cores = 2;
          memorySize = 4096;
        };
      };
    };
    testScript = ''
      etcdSystem.wait_for_unit("multi-user.target")
      etcdSystem.succeed("${haskellPackages.grapesy-etcd-testing}/bin/tests")
    '';
  };

in
grapesy-etcd-test-vm
