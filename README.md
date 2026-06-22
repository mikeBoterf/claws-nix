# claws-nix

This repository packages [clawscli/claws](https://github.com/clawscli/claws) as a Nix flake so it can be imported from other flake-based projects.

It does not contain the upstream `claws` source code. The derivation fetches a pinned upstream release and verifies the fetched source and Go module dependency tree with Nix hashes.

## Outputs

- `packages.${system}.claws`
- `packages.${system}.default`
- `apps.${system}.claws`
- `apps.${system}.default`
- `overlays.default`

Supported systems:

- `x86_64-linux`
- `aarch64-linux`
- `x86_64-darwin`
- `aarch64-darwin`

## Use As A Package

```nix
{
  inputs.claws-nix.url = "github:mboterf/claws-nix";

  outputs = { nixpkgs, claws-nix, ... }:
    let
      system = "x86_64-linux";
    in
    {
      packages.${system}.default = claws-nix.packages.${system}.claws;
    };
}
```

## Use As An Overlay

```nix
{
  inputs.claws-nix.url = "github:mboterf/claws-nix";

  outputs = { nixpkgs, claws-nix, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ claws-nix.overlays.default ];
      };
    in
    {
      packages.${system}.default = pkgs.claws;
    };
}
```

## Update For A New Upstream Release

1. Update `version` in `package.nix`.
2. Replace `src.hash` with `lib.fakeHash` and run `nix build` to get the new source hash.
3. Replace `vendorHash` with `lib.fakeHash` and run `nix build` to get the new vendor hash.
4. Run `nix flake check`.
