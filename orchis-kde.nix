{ lib, stdenvNoCC }:

let
  src = builtins.fetchGit {
    url = "https://github.com/vinceliuice/Orchis-kde";
    rev = "b2a96919eee40264e79db402b915f926436100ad";
  };
in
stdenvNoCC.mkDerivation {
  pname = "orchis-kde";
  version = "unstable-2025-10-18";

  inherit src;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # Copies the contents of directory $1 into directory $2
    copy() {
      mkdir -p "$2"
      cp -r "$1"/. "$2"/
    }

    copy aurorae               $out/share/aurorae/themes
    copy color-schemes         $out/share/color-schemes
    copy Kvantum               $out/share/Kvantum
    copy plasma/desktoptheme   $out/share/plasma/desktoptheme
    copy plasma/look-and-feel  $out/share/plasma/look-and-feel
    copy wallpaper/Orchis      $out/share/wallpapers/Orchis

    # Icons are shipped once and must exist inside each variant
    for variant in Orchis Orchis-dark; do
      copy plasma/desktoptheme/icons $out/share/plasma/desktoptheme/$variant/icons
    done

    runHook postInstall
  '';

  meta = {
    description = "Orchis theme for KDE Plasma";
    homepage = "https://github.com/vinceliuice/Orchis-kde";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}