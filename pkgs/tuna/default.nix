{ config, pkgs, lib, ... }:

let
  # Указываем версию и архитектуру
  version = "latest"; # можно заменить на конкретную версию, например, "0.27.8"
  arch = "amd64"; # для большинства систем, или "arm64"
  pname = "tuna";
in
{
  # ... остальная часть конфигурации

  environment.systemPackages = [
    (pkgs.runCommand pname { buildInputs = [ pkgs.cacert ]; } ''
      mkdir -p $out/bin

      # Скачиваем бинарный файл
      TMP_DIR=$(mktemp -d)
      cd $TMP_DIR

      # URL для скачивания бинарника tuna для Linux
      # Документация: https://tuna.am/docs/guides/install/install-cli
      URL="https://releases.tuna.am/tuna/${version}/tuna_linux_${arch}.tar.gz"
      
      echo "Downloading tuna from $URL"
      ${pkgs.curl}/bin/curl -fsSL "$URL" -o tuna.tar.gz
      
      echo "Extracting..."
      ${pkgs.gnutar}/bin/tar -xzf tuna.tar.gz
      
      echo "Installing to $out/bin/"
      cp tuna $out/bin/
      
      # Делаем исполняемым
      chmod +x $out/bin/tuna
      
      # Очистка
      cd /
      rm -rf $TMP_DIR
    '')
  ];
}
