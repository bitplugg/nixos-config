{ stdenv, buildFHSUserEnv, fetchurl, makeWrapper }:

let
  tuna-bin = stdenv.mkDerivation rec {
    pname = "tuna-bin";
    version = "0.19";
    src = fetchurl {
      url = "https://releases.tuna.am/tuna/${version}/tuna_${version}-1_amd64.deb";
      sha256 = lib.fakeSha256;
    };
    nativeBuildInputs = [ dpkg makeWrapper ];
    unpackPhase = "dpkg-deb -x $src .";
    installPhase = ''
      mkdir -p $out/bin
      cp usr/local/bin/tuna $out/bin/
    '';
  };
in
buildFHSUserEnv {
  name = "tuna-env";
  targetPkgs = pkgs: with pkgs; [ /* нужные библиотеки */ ];
  runScript = "tuna";
  profile = ''
    export PATH=${tuna-bin}/bin:$PATH
  '';
}
