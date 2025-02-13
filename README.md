# grapesy-etcd

The nix shell doesn't work, use

```
nix-shell -p zlib.dev -p protobuf -p haskell.compiler.ghc98 -p snappy
cabal build all
```

```
cabal run grapesy-etcd
```
