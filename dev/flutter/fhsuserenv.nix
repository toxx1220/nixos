{
description = "Flutter nix environment";
inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  flake-utils.url = "github:numtide/flake-utils";
  # flutter-src.url = "github:flutter/flutter";
  # flutter-src.flake = false;
};
outputs = { self, nixpkgs, flake-utils, ...} @ inputs :
  flake-utils.lib.eachDefaultSystem (system:
    let
      flutter-version = "flutter_linux_3.22.0-stable";
      flutter-url = "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/${flutter-version}.tar.xz";
      flutter-rootdir="/usr/local";
      flutter-directory="${flutter-rootdir}/${flutter-version}";

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
        with pkgs;  pkgs.buildFHSUserEnv {
          name = "flutter-env";
          targetPkgs = pkgs: (with pkgs; [
             # Flutter dependencies
            curl
            git
            unzip
            xz
            libGL

            androidSdk
            android-studio
            jdk21
          ]);
          multiBuildInputs = with pkgs; [
            stdenv.cc.cc.lib
          ];
          extraBuildCommands = "./setup.sh";
        };
    });
}
