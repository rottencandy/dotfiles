{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    hyprland
    wezterm
    rio
    emacs
    helix
    neovide
    yazi
    btop
    bottom
    jless
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
}
