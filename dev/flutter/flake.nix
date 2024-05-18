{
description = "Flutter nix environment";
inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  flake-utils.url = "github:numtide/flake-utils";
};
outputs = { self, nixpkgs, flake-utils, ...} @ inputs :
  flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        config = {
          android_sdk.accept_license = true;
          allowUnfree = true;
        };
      };
      androidComposition = pkgs.androidenv.composeAndroidPackages {
        cmdLineToolsVersion = "13.0";
        toolsVersion = null;
        platformToolsVersion = "35.0.1";
        buildToolsVersions = [ "34.0.0" ];
        includeEmulator = true;
        emulatorVersion = "35.1.4";
        platformVersions = [ "34" ];
        includeSources = false;
        includeSystemImages = false;
        systemImageTypes = [ "google_apis_playstore" ];
        abiVersions = [ "armeabi-v7a" "arm64-v8a" ];
        cmakeVersions = [ "3.10.2" ];
        includeNDK = false;
        };
        androidSdk = androidComposition.androidsdk;
    in
    {
      devShell =
        with pkgs; mkShell rec {
          buildInputs = [
            flutter
            chromium
            androidSdk
            android-studio
            jdk21
          ];
          shellHook = ''
          export CHROME_EXECUTABLE="${chromium}/bin/chromium"
          android-studio&
          '';
        };
    });
}
