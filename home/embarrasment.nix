{
  config,
  nixosConfig,
  lib,
  ...
}:
lib.mkIf nixosConfig.ppd.ai-embarrasment.enable {
  services.ollama = {
    enable = true;
    acceleration =
      if nixosConfig.ppd.rocm.enable
      then "rocm"
      else "vulkan";
    port = 11982;
  };

  programs.pi-coding-agent = {
    enable = true;
    models = {
      providers = {
        ollama = {
          api = "openai-completions";
          apiKey = "ollama";
          baseUrl = "http://localhost:11982/v1";
          models = [
            {
              id = "granite4.2:8b";
            }
          ];
        };
      };
    };
    settings = {
      defaultProvider = "ollama";
      defaultModel = "granite4.2:8b";
    };
  };
}
