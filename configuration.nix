# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./system.nix
      ./services.nix
    ];

  nix.settings.sandbox = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.fish.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    raspher = {
      isNormalUser = true;
      description = "raspher";
      extraGroups = [ "libvirtd" "networkmanager" "wheel" "docker" ];

      packages = with pkgs; [
        unstable.jetbrains.rider
        unstable.dbeaver
        unstable.discord
        unstable.onedrive
      ];
      shell = pkgs.fish;
    };

    test = {
      isNormalUser = true;
    };
  };
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # base tools
    unstable.dig
    unstable.neovim
    unstable.tmux
    unstable.wget
    unstable.vim
    unstable.killall
    # virt
    unstable.virt-manager
    # p2p
    unstable.qbittorrent
    # web
    unstable.brave
    unstable.firefox
    unstable.thunderbird
    unstable.protonvpn-gui
    # sec
    unstable.keepassxc
    # sync
    unstable.rclone
    # dev
    unstable.direnv
    unstable.gh #github-cli
    unstable.fractal
    unstable.jetbrains.idea-community
    unstable.nixd
    unstable.nix-index
    unstable.nix-init
    unstable.nix-update
    unstable.nixpkgs-review
    unstable.niv
    unstable.vscode
    unstable.zpaq
  ];

  programs.git = {
    enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
