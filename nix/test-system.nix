{ nixpkgs, pkgs, system, haskellPackages, ... }:
let
  makeTest = (import (nixpkgs + "/nixos/lib/testing-python.nix") { inherit system; }).makeTest;

  grapesy-etcd-test-vm = makeTest {
    name = "grapesy-etcd-test-vm";
    nodes = {
      alice = { ... }: {
        networking.hostName = "alice";
        environment.systemPackages = [ pkgs.etcd ];
        services.etcd = {
          advertiseClientUrls = [ "http://alice:2379" ];
          enable = true;
          extraConf = {
            "ETCD_AUTO_COMPACTION_RETENTION" = "100";
            "ETCD_AUTO_COMPACTION_MODE" = "revision";
          };
          initialAdvertisePeerUrls = [ "http://alice:2380" ];
          initialCluster = [ "alice=http://alice:2380,bob=http://bob:2380,carol=http://carol:2380" ];
          initialClusterToken = "grapesy-etcd-test";
          listenClientUrls = [ "http://127.0.0.1:2379" ];
          listenPeerUrls = [ "http://0.0.0.0:2380" ];
          name = "alice";
        };
        networking.firewall.enable = false;
        virtualisation = {
          cores = 2;
          memorySize = 2048;
        };
      };
      bob = { ... }: {
        environment.systemPackages = [ pkgs.etcd ];
        services.etcd = {
          advertiseClientUrls = [ "http://bob:2379" ];
          enable = true;
          initialAdvertisePeerUrls = [ "http://bob:2380" ];
          initialCluster = [ "alice=http://alice:2380,bob=http://bob:2380,carol=http://carol:2380" ];
          initialClusterToken = "grapesy-etcd-test";
          listenClientUrls = [ "http://127.0.0.1:2379" ];
          listenPeerUrls = [ "http://0.0.0.0:2380" ];
          name = "bob";
        };
        networking.firewall.enable = false;
        virtualisation = {
          cores = 2;
          memorySize = 2048;
        };
      };
      carol = { ... }: {
        environment.systemPackages = [ pkgs.etcd ];
        services.etcd = {
          advertiseClientUrls = [ "http://carol:2379" ];
          enable = true;
          initialAdvertisePeerUrls = [ "http://carol:2380" ];
          initialCluster = [ "alice=http://alice:2380,bob=http://bob:2380,carol=http://carol:2380" ];
          initialClusterToken = "grapesy-etcd-test";
          listenClientUrls = [ "http://127.0.0.1:2379" ];
          listenPeerUrls = [ "http://0.0.0.0:2380" ];
          name = "carol";
        };
        networking.firewall.enable = false;
        virtualisation = {
          cores = 2;
          memorySize = 2048;
        };
      };
    };
    testScript = ''
      alice.start()
      bob.start()
      carol.start()
      alice.wait_for_open_port(2379)
      bob.wait_for_open_port(2379)
      carol.wait_for_open_port(2379)
      alice.wait_for_open_port(2380)
      bob.wait_for_open_port(2380)
      carol.wait_for_open_port(2380)
      alice.succeed("etcdctl member list --endpoints http://127.0.0.1:2379")
      bob.succeed("etcdctl member list --endpoints http://127.0.0.1:2379")
      carol.succeed("etcdctl member list --endpoints http://127.0.0.1:2379")
      bob.block()
      alice.succeed("${haskellPackages.grapesy-etcd-testing}/bin/alice")
      bob.unblock()
      bob.wait_for_open_port(2379)
      bob.wait_for_open_port(2380)
      bob.succeed("etcdctl member list --endpoints http://127.0.0.1:2379")
      bob.succeed("${haskellPackages.grapesy-etcd-testing}/bin/bob")
    '';
  };

in
grapesy-etcd-test-vm
