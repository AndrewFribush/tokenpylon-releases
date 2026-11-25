# Prebuilt binary package. Build: nix-build -E 'with import <nixpkgs> {}; callPackage ./default.nix {}'
{ lib, stdenv, fetchurl }:
let
  version = "0.6.37";
  sources = {
    x86_64-linux = {
      url = "https://github.com/AndrewFribush/tokenpylon-releases/releases/download/v${version}/tokenpylon_${version}_linux_amd64.tar.gz";
      hash = "sha256-pPYLy3Yy1vyJGrR3y6OcsT9HaUN5zPQtqLwe6G//MV4=";
      dir = "tokenpylon_${version}_linux_amd64";
    };
    aarch64-linux = {
      url = "https://github.com/AndrewFribush/tokenpylon-releases/releases/download/v${version}/tokenpylon_${version}_linux_arm64.tar.gz";
      hash = "sha256-Dk2BXm663LUemnraTSsi8UHtARCgNuD2AFFQeYrMr0I=";
      dir = "tokenpylon_${version}_linux_arm64";
    };
    x86_64-darwin = {
      url = "https://github.com/AndrewFribush/tokenpylon-releases/releases/download/v${version}/tokenpylon_${version}_darwin_amd64.tar.gz";
      hash = "sha256-sr7f6BQKwi1rCYEu/wn3IbB+PhZjqyfT5ep/UuwWc5o=";
      dir = "tokenpylon_${version}_darwin_amd64";
    };
    aarch64-darwin = {
      url = "https://github.com/AndrewFribush/tokenpylon-releases/releases/download/v${version}/tokenpylon_${version}_darwin_arm64.tar.gz";
      hash = "sha256-0VfCvoMTYT5UU9u5RmctGMYQj99yQwE0WdlcQL4R50I=";
      dir = "tokenpylon_${version}_darwin_arm64";
    };
  };
  src' = sources.${stdenv.hostPlatform.system} or (throw "tokenpylon: unsupported system ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "tokenpylon";
  inherit version;
  src = fetchurl { inherit (src') url hash; };
  sourceRoot = src'.dir;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true; # keep the publisher's code signature on macOS
  installPhase = ''
    install -Dm755 tokenpylon $out/bin/tokenpylon
  '';
  meta = {
    description = "TokenPylon collector: LLM API call metadata, local usage page, usage meters";
    homepage = "https://tokenpylon.com/recorder";
    license = lib.licenses.unfree;
    mainProgram = "tokenpylon";
    platforms = builtins.attrNames sources;
  };
}
