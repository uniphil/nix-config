# also did the sysctl thing here:
# http://stackoverflow.com/questions/16748737/grunt-watch-error-waiting-fatal-error-watch-enospc

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader = {
    gummiboot.enable = true;  # efi bootloader
    efi.canTouchEfiVariables = true;
  };

  boot.extraModprobeConfig = ''
    options snd_hda_intel enable=0,1
  '';

  networking = {
    hostName = "thunk";
    firewall.enable = true;
    wireless.enable = true;
  };

  i18n.defaultLocale = "en_CA.UTF-8";

  time.timeZone = "America/Montreal";


  nixpkgs.config = {
    allowUnfree = true;
    firefox = {
      #enableAdobeFlash = true;
      #enableGoogleTalkPlugin = true;
    };
    chromium = {
      enableGoogleTalkPlugin = true;
      enablePepperFlash = true;
      enablePepperPDF = true;
    };
    packageOverrides = pkgs: {
      bluez = pkgs.bluez5;
    };
  };

  environment.systemPackages = with pkgs; [
    abiword
    acpi
    alsaUtils
    arandr
    atom
    bashCompletion
    chromium
    dmenu
    evince
    feh
    firefox
    gcc
    #gdal  #  <- buld broke :( may 1 2015
    gimp
    git
    gnumake
    gnumeric
    gparted
    htop
    imagemagick
    inkscape
    keepassx
    libsass
    nginx
    #nodejs
    #nodejs-0_10
    iojs
    pavucontrol
    pdftk
    phantomjs
    python3
    qpdf
    redshift
    rsync
    scrot
    skype
    sqlite
    sublime3
    subversion
    terminator
    transmission_gtk
    unrar
    unzip
    linuxPackages.virtualbox
    vlc
    w3m
    which
    wine
    xpdf
  ];

  hardware.pulseaudio.enable = true;
  hardware.bluetooth.enable = true;

  services.virtualbox.host.enable = true;

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
    startWhenNeeded = true;
  };

  services.printing.enable = true;

  services.ntp = {
    enable = true;
    servers = [ "0.pool.ntp.org" "1.pool.ntp.org" "2.pool.ntp.org" ];
  };

  services.redshift = {
    enable = true;
    latitude = "44.25";
    longitude = "-76.5";
  };

  services.xserver = {
    enable = true;
    layout = "us";

    displayManager = {
      slim.defaultUser = "phil";
      desktopManagerHandlesLidAndPower = false;
    };

    windowManager = {
      xmonad.enable = true;
      xmonad.enableContribAndExtras = true;
      default = "xmonad";
    };

    desktopManager = {
      default = "none";
      xterm.enable = false;
    };

    videoDrivers = [ "intel" ];
    vaapiDrivers = [ pkgs.vaapiIntel ];
    xkbOptions = "ctrl:nocaps";
    synaptics = {
      #buttonsMap = [ 1 3 2 ];
      enable = true;
      maxSpeed = "1.5";
      twoFingerScroll = true;
      vertEdgeScroll = false;
    };
    #multitouch = {
    #  enable = true;
    #  invertScroll = true;
    #};
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts  # ms
      inconsolata  # mono
      ubuntu_font_family
      dejavu_fonts
    ];
  };

  programs.bash.enableCompletion = true;
}
