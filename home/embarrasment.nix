{
  config,
  nixosConfig,
  lib,
  ...
}:
lib.mkIf nixosConfig.ppd.ai-embarrasment.enable {
  services.ollama = {
    enable = true;
    acceleration = "vulkan";
    port = 11982;
  };

  programs.claude-code = {
    enable = true;
  };
}
