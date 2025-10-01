{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable-small";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { localSystem = system; };

        misskey = pkgs.callPackage ./nix/build.nix rec {
          nodejs = pkgs.nodejs_22;
          pnpm = pkgs.pnpm_11;
          node-gyp = pkgs.node-gyp.override {
            inherit nodejs;
          };
        };

        misskey-image = pkgs.callPackage ./nix/image.nix {
          inherit misskey;
        };
      in
      {
        packages = {
          inherit misskey misskey-image;
        };

        apps = {
          stream-image = {
            type = "app";
            program = "${misskey-image}";
          };
        };

        devShell = pkgs.mkShell {
          name = "misskey-dev";

          packages = with pkgs; [
            nodejs_22
            pnpm_11

            ffmpeg
            postgresql
            valkey
          ];
        };
      }
    );
}
