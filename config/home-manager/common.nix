{ config, pkgs, ... }:

let

  pkgsUnstable = import <nixpkgs-unstable> {};

in

{
  home.packages = with pkgs; [
    hyprland
    hyprpaper
    mako
    wezterm
    emacs
    helix
    neovide
    yazi
    broot
    btop
    bottom
    jless
    fx
    gron
    yq-go
    xh
    yt-dlp
    gum
    todo-txt-cli
  ];

  home.file = {
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/msaud/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.rio = {
    enable = true;
    settings = {
      padding-x = 14;
      # https://github.com/mbadolato/iTerm2-Color-Schemes/blob/master/rio/Jellybeans.toml
      background = {
        opacity = 0.5;
      };
      colors = {
        background = "#040404";
        foreground = "#feffff";
        selection-background = "#606060";
        selection-foreground = "#ffffff";
        cursor = "#feffff";
        black = "#040404";
        red = "#d84a33";
        green = "#5da602";
        yellow = "#eebb6e";
        blue = "#417ab3";
        magenta = "#e5c499";
        cyan = "#bdcfe5";
        white = "#dbded8";
        light_black = "#685656";
        light_red = "#d76b42";
        light_green = "#99b52c";
        light_yellow = "#ffb670";
        light_blue = "#97d7ef";
        light_magenta = "#aa7900";
        light_cyan = "#bdcfe5";
        light_white = "#e4d5c7";
      };
    };
  };
}

# vim: fdm=marker:fdl=0:et:sw=2:
