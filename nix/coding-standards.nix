{
  perSystem = { self', lib, ... }: {
    coding.standards.hydra = {
      enable = true;
      haskellPackages = with self'.packages; [
        etcd-embed
        grapesy-etcd
        grapesy-etcd-testing
        proto-lens-etcd
        which-embed
      ];
      haskellFormatter = "ormolu";
    };
    weeder.enable = lib.mkForce false;
    werrorwolf.extra-flags = lib.mkForce [ ];
  };

}
