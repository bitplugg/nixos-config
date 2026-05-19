{ pkgs, lib }:

let
  version = "0.19";
  arch = "amd64";
in
pkgs.buildFHSEnv {
  name = "tuna";
  targetPkgs = pkgs: with pkgs; [ zlib glib ];
  runScript = "tuna";
  profile = ''
    export PATH="${pkgs.stdenv.mkDerivation {
      pname = "tuna-bin";
      inherit version;
      src = pkgs.fetchurl {
        url = "https://releases.tuna.am/tuna/${version}/tuna_linux_${arch}.tar.gz";
        hash = "";   # при первой сборке Nix вычислит правильный хеш
      };
      unpackPhase = "tar xzf $src";
      installPhase = ''
        mkdir -p $out/bin
        cp tuna $out/bin/
        chmod +x $out/bin/tuna
      '';
    }}/bin:$PATH"
  '';
  meta = with lib; {
    description = "Российский аналог ngrok для создания защищенных туннелей";
    homepage = "https://tuna.am";
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
