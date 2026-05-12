{ stdenv
, buildFHSUserEnv
, fetchurl
, dpkg
, makeWrapper
, lib
, zlib
, glib
, stdenv.cc.cc
}:

let
  tuna-bin = stdenv.mkDerivation rec {
    pname = "tuna-bin";
    version = "0.19";
    src = fetchurl {
      url = "https://releases.tuna.am/tuna/${version}/tuna_${version}-1_amd64.deb";
      hash = lib.fakeSha256;
    };
    nativeBuildInputs = [ dpkg makeWrapper ];
    unpackPhase = "dpkg-deb -x $src .";
    installPhase = ''
      mkdir -p $out/bin
      cp usr/local/bin/tuna $out/bin/
    '';
  };
in buildFHSUserEnv {
  name = "tuna-env";
  targetPkgs = pkgs: with pkgs; [ zlib glib stdenv.cc.cc ];
  runScript = "tuna";
  profile = ''
    export PATH=${tuna-bin}/bin:$PATH
  '';
  meta = with lib; {
    description = "Российский аналог ngrok для создания защищенных туннелей";
    homepage = "https://tuna.am";
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
