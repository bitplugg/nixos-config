{ config, pkgs, lib, ... }:

let
  # Список доменов, к которым применяем обход (бывший whitelist)
  hostlist = pkgs.writeText "zapret-hostlist.txt" ''
    # Discord
    .discord.com
    .discord.gg
    .discordapp.com
    .discordmedia.com
    # GitHub
    .github.com
    .githubusercontent.com
    .githubassets.com
    .github.io
    # Google / YouTube
    .youtube.com
    .youtu.be
    .ytimg.com
    .googlevideo.com
    .google.com
    .googleapis.com
    .ggpht.com
    .gstatic.com
    # Telegram
    .telegram.org
    .tdesktop.com
    .t.me
    .telegra.ph
    .telesco.pe
    .cdn.telegram.org
    .plg.telegram.org
    # ChatGPT / OpenAI
    .chatgpt.com
    .openai.com
    .chat.openai.com
    .auth.openai.com
    .api.openai.com
    .oaistatic.com
    .oaiusercontent.com
    .statsig.com
    .intercom.io
    .intercomcdn.com
    .featuregates.org
    # Cloudflare (все основные домены)
    .cloudflare.com
    .cloudflare.net
    .cloudflare-cn.com
    .cloudflare-dns.com
    .cloudflare-ech.com
    .cloudflare-esni.com
    .cloudflare-gateway.com
    .cloudflare-quic.com
    .cloudflareaccess.com
    .cloudflareapps.com
    .cloudflarebolt.com
    .cloudflareclient.com
    .cloudflareinsights.com
    .cloudflareok.com
    .cloudflarepartners.com
    .cloudflareportal.com
    .cloudflarepreview.com
    .cloudflareresolve.com
    .cloudflaressl.com
    .cloudflarestatus.com
    .cloudflarestorage.com
    .cloudflarestream.com
    .cloudflaretest.com
    .cloudflarewarp.com
    .one.one.one.one
    .cf-ips.com
    .cf-ns.com
    .pages.dev
    .workers.dev
    .r2.cloudflarestorage.com
    .teams.cloudflare.com
    .gateway.cloudflare.com
  '';
in {
  services.zapret = {
    enable = true;
    params = [
      "--dpi-desync=fake,split2"
      "--dpi-desync-autottl=2"
      "--dpi-desync-fooling=md5sig"
      "--hostlist=${hostlist}" # ← применяем обход только к этому списку
    ];
    # Whitelist оставляем пустым — нет исключений
    whitelist = [ 
      "cache.nixos.org"
      "nix-community.cachix.org"
    ];
  };
}


