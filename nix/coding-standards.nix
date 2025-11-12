{
  perSystem = { self', lib, ... }: {
    coding.standards.hydra = {
      enable = true;
      haskellPackages = with self'.packages; [
        grapesy-etcd
        grapesy-etcd-testing
        proto-lens-etcd
      ];
      haskellFormatter = "ormolu";
    };
    weeder.enable = lib.mkForce false;
    werrorwolf.extra-flags = lib.mkForce [ ];
  };

}
