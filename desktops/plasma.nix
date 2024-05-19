{ config, pkgs, inputs, ... }:

{
	services.desktopManager.plasma6.enable = true;
  
  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
      
  # Configure keymap in X11
    xkb = {
			layout = "us, de(qwerty)";
			variant = "";
    };
  };

	environment = {
    systemPackages = with pkgs; [
      libsForQt5.xdg-desktop-portal-kde
			xdg-desktop-portal
    ];
}
