# Docs: https://devenv.sh/basics/
{ pkgs, inputs, ... }:
let
  # https://devenv.sh/common-patterns/#getting-a-recent-version-of-a-package-from-nixpkgs-unstable
  pkgs-latest = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in
{

  languages = {
    # Docs: https://devenv.sh/languages/
    nix.enable = true;
    javascript = {
      enable = true; # source: https://github.com/cachix/devenv/blob/main/src/modules/languages/javascript.nix
      corepack.enable = true; # Enable corepack for pnpm management
      # TODO remove whichever you don't need:
      npm.enable = true;
      pnpm = {
        enable = true;
        package = pkgs-latest.nodePackages.pnpm;
      };
      yarn.enable = true;
    };
    typescript.enable = true;
  };

  packages = with pkgs; [
    gcc # needed for some npm packages
    stdenv.cc.cc.lib # C++ standard library for native modules
    gnumake # needed for make commands
    sqlite # database for development
    (python3.withPackages (ps: [ ps.setuptools ])) # needed for node-gyp with distutils
    openssl # needed for Prisma
    nodePackages.typescript-language-server # many editors benefit from this

    # Search for packages: https://search.nixos.org/packages?channel=unstable&query=cowsay
    # (note: this searches on unstable channel, you might need to use pkgs-latest for some):
    #pkgs-latest.task-keeper
  ];

  scripts = { }; # Docs: https://devenv.sh/scripts/

  env = {
    LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
    OPENSSL_DIR = "${pkgs.openssl.dev}";
  };

  git-hooks.hooks = {
    # Docs: https://devenv.sh/pre-commit-hooks/
    # list of pre-configured hooks: https://devenv.sh/reference/options/#pre-commithooks
    nil.enable = true; # nix lsp
    nixpkgs-fmt.enable = true; # nix formatting
    eslint = {
      # enable = true; # TODO disabled by default as it fails if no eslint config exists
      files = "\.(js|ts|vue|jsx|tsx)$";
      fail_fast = true; # skip other pre-commit hooks if this one fails
    };
  };

  difftastic.enable = true; # enable semantic diffs - https://devenv.sh/integrations/difftastic/
}
