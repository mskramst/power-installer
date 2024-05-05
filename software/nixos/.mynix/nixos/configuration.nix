# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, callPackage, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
#      <home-manager/nixos>
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
   #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
   networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
   time.timeZone = "America/Los_Angeles";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";r
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  environment.pathsToLink = [ "/libexec" ];

  environment.variables = {
	      EDITOR = "vim";
        BROWSER = "brave";
        TERM = "kitty";
  };

  services.xserver = {
      enable = true;
     
      desktopManager = {
	      xterm.enable = false;
      };
      
      displayManager =  {
        defaultSession = "none+i3";

        lightdm = {
        enable = true;
        greeter.enable = false;

        autoLogin = {
          enable = true;
          user = "mskramst";
        };
      };

  };

  windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
	     dmenu
       i3status
       i3lock
       i3blocks
      ];
    };
     
};

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
   sound.enable = true;
   hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.mskramst = {
     isNormalUser = true;
     extraGroups = [ 
         "wheel" 
      	 "root"
         "networkmanager"
     ]; # Enable ‘sudo’ for the user.
     packages = with pkgs; [
        brave 
     ];
   };

  nixpkgs.config.allowUnfree = true; 
  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
     acpi
     feh
     fontconfig
     firefox
     jq
     kitty
     git
     go
     ly
     mpv
     nerdfonts
     networkmanagerapplet
     rofi
     pavucontrol
     pulseaudioFull
     pasystray
     python3
     sqlite
     tmux
     vscode
     w3m
     unzip
     wget
     vim 
   ];

   fonts = {
    packages = with pkgs; [
            noto-fonts
            noto-fonts-cjk
            noto-fonts-emoji
            font-awesome
            source-han-sans
      (nerdfonts.override {fonts = ["Meslo"];})
	  ];

	  fontconfig = {
	    enable = true;
          defaultFonts = {
		            monospace= ["Meslo LG M Regular Nerd Font Complete Mono"];
                serif = ["Noto Serif" "Soure Han Serif"];
                sansSerif = ["Noto Sans" "Source Hans Sans"];
	   };
	  };
   };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
   networking.firewall.enable = false;

  system.stateVersion = "23.11"; # Did you read the comment?

}

