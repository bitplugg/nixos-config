{ pkgs, lib }:

let
  tuna-bin = pkgs.stdenv.mkDerivation rec {
    pname = "tuna-bin";
    version = "0.19";
    src = pkgs.fetchurl {
      url = "https://releases.tuna.am/tuna/${version}/tuna_${version}-1_amd64.deb";
      hash = lib.fakeSha256;   # после первой сборки замените на реальный хеш
    };
    nativeBuildInputs = [ pkgs.dpkg ];
    unpackPhase = "dpkg-deb -x $src .";
    installPhase = ''
      mkdir -p $out/bin
      cp usr/local/bin/tuna $out/bin/
    '';
  };
in
pkgs.buildFHSUserEnv {
  name = "tuna";
  targetPkgs = pkgs: with pkgs; [ zlib glib ];
  runScript = "tuna";
  profile = ''
    export PATH="${tuna-bin}/bin:$PATH"
  '';
  meta = with lib; {
    description = "Российский аналог ngrok для создания защищенных туннелей";
    homepage = "https://tuna.am";
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
