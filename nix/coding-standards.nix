{
  perSystem = { self', lib, ... }: {
    coding.standards.hydra = {
      enable = true;
      haskellPackages = with self'.packages; [
        grapesy-etcd
        grapesy-etcd-testing
        proto-lens-etcd
      ];
    };
    werrorwolf.extra-flags = lib.mkForce [ ];
  };

}
