{
  description = "Nix package for clawscli/claws";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;

      packageFor =
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        in
        pkgs.claws;
    in
    {
      overlays.default = final: _prev: {
        claws = final.callPackage ./package.nix { };
      };

      packages = forAllSystems (system: {
        claws = packageFor system;
        default = packageFor system;
      });

      apps = forAllSystems (
        system:
        let
          claws = nixpkgs.lib.getExe self.packages.${system}.claws;
        in
        {
          claws = {
            type = "app";
            program = claws;
          };
          default = {
            type = "app";
            program = claws;
          };
        }
      );
    };
}
