{ stdenv, dpkg, fetchurl }:

stdenv.mkDerivation rec {
  pname = "tuna";
  version = "0.19";

  src = fetchurl {
    url = "https://releases.tuna.am/tuna/${version}/tuna_${version}-1_amd64.deb";
    hash = lib.fakeSha256; # Замените на реальный хеш
  };

  nativeBuildInputs = [ dpkg ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    mkdir -p $out/bin
    cp -r usr/local/bin/* $out/bin/
    chmod +x $out/bin/tuna
  '';

  meta = with lib; {
    description = "Российский аналог ngrok для создания защищенных туннелей";
    homepage = "https://tuna.am";
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
