{
  description = "A Java development environment with IntelliJ";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true; # IntelliJ IDEA is unfree software
          };
        };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            # JDK and necessary tools
            openjdk21 # or another version like openjdk15, etc.
            maven # if you use Maven
            gradle # if you use Gradle

            # IntelliJ IDEA Community (Uncomment the following line for the Ultimate version)
            #idea-community
            jetbrains.idea-ultimate

            # Other tools you might need
            git
            # Any other packages you need...
          ];

          # Optional environment variables
          # JAVA_HOME is usually set automatically, but you can set it if needed
          # environment.variables.JAVA_HOME = "${pkgs.openjdk11.home}";
        };
      }
    );
}