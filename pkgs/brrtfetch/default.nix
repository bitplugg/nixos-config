{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "brrtfetch";
  version = "latest";

  src = fetchFromGitHub {
    owner = "ferrebarrat";
    repo = "brrtfetch";
    rev = "95233c2fbf5a514a0ab7910ae3ea002d642fc5f7";
    hash = "sha256-qBrNw7x7TkGmBhT4Py/FNnmBJbD3angCKsvxq/nSqLY=";   # первая попытка — ошибка, Nix подставит правильный
  };

  vendorHash = "sha256-qBrNw7x7TkGmBhT4Py/FNnmBJbD3angCKsvxq/nSqLY=";  # то же самое

  meta = {
    description = "Render animated ASCII art from a GIF for your sysinfo fetcher of choice";
    homepage = "https://github.com/ferrebarrat/brrtfetch";
    license = lib.licenses.mit;
    mainProgram = "brrtfetch";
  };
}
