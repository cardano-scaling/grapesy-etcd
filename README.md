# grapesy-etcd

This repository contains a [grapesy](https://hackage.haskell.org/package/grapesy) client
for [etcd](http://etcd.io).

It is divided into two packages

* [grapesy-etcd](grapesy-etcd/) - Contains the library code and protocol buffer bindings, released to hackage under [grapesy-etcd](https://hackage.haskell.org/package/grapesy-etcd).
* [grapesy-etcd-testing](grapesy-etcd-testing) - Contains an executable (not cabal test) for running a test against a live etcd service.

## Development

Do this to get started.

```
nix develop
cabal build all
```

## Testing

Testing the must be done against a real etcd service, which is provided by a NixOS VM test in a flake check attribute. To run all of the tests, run

```
nix flake check
```

You may run the test executable against a version of etcd installed on your host if you wish.
