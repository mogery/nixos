{ pkgs, ... }:

{
    home.packages =
        let
            cider = with pkgs; appimageTools.wrapType2 rec {
                pname = "cider";
                version = "2.4.0";

                src = requireFile {
                    name = "Cider-linux-appimage-x64.AppImage";
                    url = "https://cidercollective.itch.io/cider";
                    sha256 = "1ds7grjr52ssf1q0sm9jk7hxhskfxj6b5pzrmibliglhbzblflx7";
                    message = ''
                        Cider not found.
                        1. acquire Cider-linux-appimage-x64.AppImage from itch.io
                        2. in a shell, execute:
                            nix-prefetch-url file:///path/to/Cider-linux-appimage-x64.AppImage
                    '';
                };

                extraInstallCommands =
                    let contents = appimageTools.extract { inherit pname version src; };
                    in ''
                    install -m 444 -D ${contents}/${pname}.desktop -t $out/share/applications
                    substituteInPlace $out/share/applications/${pname}.desktop \
                        --replace 'Exec=AppRun' 'Exec=${pname}'
                    cp -r ${contents}/usr/share/icons $out/share
                    '';

                meta = with lib; {
                    description = "A new look into listening and enjoying Apple Music in style and performance.";
                    homepage = "https://cidercollective.itch.io/cider";
                    platforms = [ "x86_64-linux" ];
                };
            };
        in
        [ cider ];
}
