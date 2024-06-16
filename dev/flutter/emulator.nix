with import <nixpkgs>{
 config.android_sdk.accept_license = true;
 config.allowUnfree = true;
};

androidenv.emulateApp {
  name = "emulate-MyAndroidApp";
  platformVersion = "34";
  abiVersion = "armeabi-v7a"; # mips, x86, x86_64
  systemImageType = "default";
}