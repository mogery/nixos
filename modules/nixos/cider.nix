{ pkgs, ... }:

{
    users.users.mogery.packages =
        let
            cider = with pkgs; appimageTools.wrapType2 rec {
                pname = "cider";
                version = "1.3.1308";

                src = requireFile {
                    name = "Cider-2.3.1.AppImage";
                    url = "https://cidercollective.itch.io/cider";
                    sha256 = "19plc5dj7bh1gf5nq096kpj6c4bqx3xbsffvwfjshmlwz82dwa1p";
                };

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
                    description = "A new look into listening and enjoying Apple Music in style and performance.";
                    homepage = "https://cidercollective.itch.io/cider";
                    platforms = [ "x86_64-linux" ];
                };
            };
        in
        [ cider ];
}