# Cardano-Docker

Starter docker file based on `ubuntu` for building cardano projects with ghc.
It adds `ghc`  and all the libraries required to build `cardano-node` or `cardano-api`from source. 
It includes libraries from ubuntu software channel and following extra libraries built from source.
- iohk-libsodium
- libsecp256
- libblst

[View in DockerHub](https://hub.docker.com/r/cardanoapi/haskell)

### Available images:
  - `cardanoapi/haskell:latest` (uses haskell v9.6.7)
  - `cardanoapi/haskell:9.6.7`
  - `cardanoapi/haskell:9.4.8`

### Todos:
- [ ] Make the image size smaller by removing profiling libraries
- [ ] nonroot.Dockerfile is not ready