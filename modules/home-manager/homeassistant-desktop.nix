{ pkgs, ... }:

{
    home.packages =
        let
            homeassistant-desktop = with pkgs; appimageTools.wrapType2 rec {
                pname = "homeassistant-desktop";
                version = "1.5.3";

                src =
                    let
                        urls = {
                            "x86_64-linux" = {
                                url = "https://github.com/iprodanovbg/homeassistant-desktop/releases/download/v1.5.3/Home-Assistant-Desktop-v1.5.3-linux-x86_64.AppImage";
                                sha256 = "00a7sv2xkdl1g1xkmw2l9xmisf32nb3lawrpj6dmqgwhp9fk3pnh";
                            };
                            "aarch64-linux" = {
                                url = "https://github.com/iprodanovbg/homeassistant-desktop/releases/download/v1.5.3/Home-Assistant-Desktop-v1.5.3-linux-arm64.AppImage";
                                sha256 = "11718asrp9mymw02y7fd2v241vx4g74xz1qpdd2kxw5c8c2b3ps4";
                            };
                        };
                    in
                        fetchurl urls."${stdenvNoCC.hostPlatform.system}";

                extraInstallCommands =
                    let contents = appimageTools.extract { inherit pname version src; };
                    in ''
                    mv $out/bin/${pname}-${version} $out/bin/${pname}
                    install -m 444 -D ${contents}/${pname}.desktop -t $out/share/applications
                    substituteInPlace $out/share/applications/${pname}.desktop \
                        --replace 'Exec=AppRun' 'Exec=${pname}'
                    cp -r ${contents}/usr/share/icons $out/share
                    '';

                meta = with lib; {
                    description = "Desktop application for Home Assistant built with Electron";
                    homepage = "https://github.com/iprodanovbg/homeassistant-desktop";
                    platforms = [ "x86_64-linux" "aarch64-linux" ];
                };
            };
        in
        [ homeassistant-desktop ];
}