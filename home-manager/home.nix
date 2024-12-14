{ config, pkgs, ... }:

{
  home.username = "hikary";
  home.homeDirectory = "/home/hikary";

  home.stateVersion = "24.11";

  imports = [
    ./programs/kitty.nix
    ./theme.nix
    (import (builtins.fetchTarball {
      url = "https://github.com/danth/stylix/archive/master.tar.gz";
      sha256 = "sha256:0lilaanla6fwcfs24lm7dbb9ww9cidwwk451jvblmr7qi4nrwis3"; 
    })).homeManagerModules.stylix
  ];

  nixpkgs.overlays = [
    (final: prev: {
      nixgl = import (builtins.fetchTarball {
        url = "https://github.com/nix-community/nixGL/archive/main.tar.gz";
      }) { };
    })
  ];

  home.packages = with pkgs; [ ];

  home.file = {
  };

  programs.home-manager.enable = true;
}
