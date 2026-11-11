{ config, lib, pkgs, ... }:

let
  cfg = config.theme.orchis;
  orchis-kde = pkgs.callPackage ./orchis-kde.nix { };
in
{
  options.theme.orchis = {
    enable = lib.mkEnableOption "tema Orchis (Plasma + GTK)";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      orchis-kde
      pkgs.orchis-theme
      pkgs.kdePackages.qtstyleplugin-kvantum
      pkgs.tela-circle-icon-theme
      pkgs.vimix-cursors
    ];
  };
}