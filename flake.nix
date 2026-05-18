{
  description = "FrostPhoenix's nixos configuration";
  

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nur.url = "github:nix-community/NUR";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    maple-mono = {
      url = "github:subframe7536/maple-font?ref=v7.8";
      flake = false;
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
    };
    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    superfile.url = "github:yorukot/superfile";
    zen-browser.url = "github:0xc000022070/zen-browser-flake/beta";
    opencode.url = "github:sst/opencode";
    nixos-pack.url = "github:bitplugg/nixos-pack";
    nix-openclaw.url = "github:openclaw/nix-openclaw";
    #inputs.nixvim.homeModules.nixvim = "github:nix-community/nixvim";
    nixvim.url = "github:nix-community/nixvim";    #добавь это как отдельный вход
    #inputs.nixvim.url = "github:nix-community/nixvim";
    #zapret.url = ""
    #opencode-flake.url = "github:aodhanhayter/opencode-flake";ш
#    opencode-flake.url = "github:AodhanHayter/opencode-flake";
#programs.ssh.startAgent = true;
};
# programs.ssh.startAgent = true;


  outputs =
    { nixpkgs, self, nix-openclaw, ... }@inputs:
    let
      username = "bitplugg";
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        inherit nix-openclaw;
      };
#      enivroment.systemPackages {
#        antigravity-nix.packages.x86_64-linux.default
#      };
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/desktop ];
          specialArgs = {
            host = "desktop";
            inherit self inputs username;
          };
        };
        laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/laptop ];
          home-manager.nixosModules.home-manager
          specialArgs = {
            host = "laptop";

            inherit self inputs username;
          };
        };
        p14s = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/p14s ];
          specialArgs = {
            host = "p14s";
            inherit self inputs username;
          };
        };
        vm = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/vm ];
          specialArgs = {
            host = "vm";
            inherit self inputs username;
          };
        };
      };      
    packages.${system} = {
      brrtfetch = pkgs.callPackage ./pkgs/brrtfetch {};
      rkn-block-checker = pkgs.callPackage ./pkgs/rkn-block-checker {};
      #default = self.packages.${system}.brrtfetch;
    };
  };
}
