{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "brrtfetch";
  version = "latest";

  src = fetchFromGitHub {
    owner = "ferrebarrat";
    repo = "brrtfetch";
    rev = "master";
    hash = lib.fakeSha256;   # первая попытка — ошибка, Nix подставит правильный
  };

  vendorHash = lib.fakeSha256;  # то же самое

  meta = {
    description = "Render animated ASCII art from a GIF for your sysinfo fetcher of choice";
    homepage = "https://github.com/ferrebarrat/brrtfetch";
    license = lib.licenses.mit;
    mainProgram = "brrtfetch";
  };
}
