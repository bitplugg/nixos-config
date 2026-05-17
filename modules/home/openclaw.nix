# ./modules/home/openclaw.nix
{ config, lib, pkgs, inputs, ... }:

let
  # Путь к файлу с секретами
  secretsFile = "/home/bitplugg/.secrets/openclaw.env";
  # Функция для подстановки секретов из внешнего TOML-файла
  secrets = if builtins.pathExists secretsFile then
    lib.strings.substituteAll (lib.importTOML secretsFile)
  else
    {};

  mistralApiKey = secrets.mistralApiKey or "";
  mistralBaseURL = "https://api.mistral.ai/v1";

in {
  imports = [ "${inputs.nix-openclaw}/homeManagerModules/default.nix" ];

  programs.openclaw = {
    enable = true;

    # ============================================
    # Основная конфигурация OpenClaw (будет в openclaw.json)
    # ============================================
    config = {
      # --------------------------------------------------
      # 1. Настройки ИИ-моделей (Mistral AI)
      # --------------------------------------------------
      models = {
        default = "mistral/mistral-small-latest";
        allow = [
          "mistral/mistral-large-latest"
          "mistral/mistral-small-latest"
          "mistral/open-mistral-nemo"
          "mistral/codestral-latest"
        ];
        providers = {
          mistral = {
            api = "openai";
            baseUrl = mistralBaseURL;
            apiKey = mistralApiKey;
          };
        };
      };

      # --------------------------------------------------
      # 2. Настройки агента (промпт и режим работы)
      # --------------------------------------------------
      agent = {
        systemPrompt = ''
          You are an AI assistant integrated into the user's NixOS system via OpenClaw. 
          You are helpful, concise, and safe. Your responses should be in the same language as the user's query.

          ## Your Core Capabilities (Skills)

          You have access to the following skills. Use them proactively when the user asks for something:

          1.  **weather (Built-in)**
              - Use this for ANY weather-related questions (current weather, forecasts, wind, humidity).
              - It requires no API key and uses free data sources.
              - **Example triggers:** "What's the weather like in London?", "Will it rain tomorrow?", "Show me a 3-day forecast for Tokyo."
              - **How to use:** Just ask naturally. The system will handle the query.

          2.  **coding-agent (Built-in)**
              - Use this for writing, reviewing, explaining, or debugging code.
              - You can generate code snippets, write entire scripts, or help fix errors.
              - **Example triggers:** "Write me a Python script to download a CSV from a URL.", "Explain this Rust code:", "Find the bug in this JavaScript function."

          3.  **file (Built-in)**
              - Use this to read, write, edit, or delete files on the local system.
              - **Allowed paths:** `/home/bitplugg` and `/tmp`.
              - **Example triggers:** "Create a file called notes.txt in my home folder.", "Show me the contents of my NixOS config."

          4.  **shell (Built-in)**
              - Use this to execute system commands for getting information or performing tasks.
              - **Allowed commands:** `ls`, `cat`, `grep`, `find`, `ps`, `df`, `du`, `git status`
              - **Blocked commands:** `rm -rf`, `sudo`, `chmod`, `chown`, `kill`, `shutdown`
              - **Example triggers:** "List all files in the current directory.", "Show me my git status."

          5.  **web (Optional)**
              - Use this to search the internet. It requires a Brave API key to function.
              - **Example triggers:** "Search for the latest news on NixOS.", "Find the best Italian restaurant near me."

          6.  **notebook (Optional)**
              - Use this to keep persistent notes across conversations.
              - **Storage path:** `/home/bitplugg/.openclaw/notebook`
              - **Example triggers:** "Remember that my favorite color is blue.", "What notes do I have saved?"

          ## Instructions

          - When a request matches a skill, use it.
          - For `shell` or `file` actions, briefly explain what you're going to do before executing.
          - For `coding-agent`, provide clean, well-commented code and a brief explanation.
          - For `weather`, respond with the weather information in a clear, natural way.
          - If a request cannot be fulfilled, politely explain why and suggest an alternative.
        '';
      };

      # --------------------------------------------------
      # 3. Включение и настройка Скиллов (Skills)
      # --------------------------------------------------
      skills = {
        # Встроенный навык погоды
        weather = {
          enable = true;
          # Использует бесплатные API (wttr.in, Open-Meteo)
          # Никаких ключей не требуется
        };

        # Встроенный навык для написания кода
        coding-agent = {
          enable = true;
        };

        # Навык для работы с файлами
        file = {
          enable = true;
          allowedPaths = [ "/home/bitplugg" "/tmp" ];
        };

        # Навык для выполнения shell-команд
        shell = {
          enable = true;
          allowedCommands = [
            "ls" "cat" "grep" "find" "ps" "df" "du"
            "git status" "git diff"
          ];
          blockedCommands = [
            "rm -rf" "sudo" "chmod" "chown" "kill" "shutdown"
          ];
        };

        # Необязательные навыки, требующие дополнительной настройки
        web = {
          enable = true;
          provider = "duckduckgo";
          };
        notebook = {
          enable = true;
          storagePath = "/home/bitplugg/.openclaw/notebook";
        };
      };
    };
  };
}
