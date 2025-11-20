{ config, ... }:

{
  # TouchID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # System settings
  system.defaults.screencapture.type = "jpeg";
  system.defaults.NSGlobalDomain.NSWindowShouldDragOnGesture = true;

  # Set Git commit hash for darwin-version
  system.configurationRevision = config.rev or config.dirtyRev or null;
}
