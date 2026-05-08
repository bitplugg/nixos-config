{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "brrtfetch";
  version = "unstable-2024-11-24";

  src = fetchFromGitHub {
    owner = "ferrebarrat";
    repo = "brrtfetch";
    rev = "c1f327999cd3dd4dde163d183a699c73979c0fa5";
    hash = "sha256-P6oEAL7pXGjKf6D+/IIuZgwjP2NHWeh6qx28ac1Y8Go=";
  };

  vendorHash = "sha256-pQpattmS9VmO3ZIh4gkkYj2DXR3qYyYAc3Y4h/gM8K4=";

  meta = {
    description = "Render animated ASCII art from a GIF for your sysinfo fetcher of choice";
    homepage = "https://github.com/ferrebarrat/brrtfetch";
    license = lib.licenses.mit;
    mainProgram = "brrtfetch";
  };
}
