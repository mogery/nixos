{ pkgs, ... }:

{
    fonts = {
        enableDefaultPackages = true;
        packages = [
            (pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
                pname = "berkeley-mono";
                version = "1.009-Lstd-03-71"; # version 1.009, ligatures: standard, zero: strikethrough (3rd variant), seven: simple (1st variant)

                src = pkgs.requireFile {
                    name = "${finalAttrs.pname}-${finalAttrs.version}.zip";
                    sha256 = "0w702gjd9v9nq2va9ph072xsvc7qn7nhw7zb6hf8wiikrjiz46a2";
                    message = ''
                        This file needs to be manually downloaded from the Berkeley Graphics
                        site (https://berkeleygraphics.com/accounts). An email will be sent to
                        get a download link.

                        Then run:

                        mv berkeley-mono-typeface.zip ${finalAttrs.pname}-${finalAttrs.version}.zip
                        nix-prefetch-url --type sha256 file://\$PWD/${finalAttrs.pname}-${finalAttrs.version}.zip
                    '';
                };

                outputs = [ "out" "web" "variable" "variableweb" ]; 

                nativeBuildInputs = [
                    pkgs.unzip
                ];

                unpackPhase = ''
                    unzip $src
                '';

                installPhase = ''
                    runHook preInstall

                    install -D -m444 -t $out/share/fonts/opentype berkeley-mono/OTF/*.otf
                    install -D -m444 -t $out/share/fonts/truetype berkeley-mono/TTF/*.ttf
                    install -D -m444 -t $web/share/fonts/webfonts berkeley-mono/WEB/*.woff2
                    install -D -m444 -t $variable/share/fonts/truetype berkeley-mono-variable/TTF/*.ttf
                    install -D -m444 -t $variableweb/share/fonts/webfonts berkeley-mono-variable/WEB/*.woff2

                    runHook postInstall
                '';

                meta = with pkgs.lib; {
                    description = "A love letter to the golden era of computing.";
                    homepage = "https://berkeleygraphics.com/typefaces/berkeley-mono/";
                    downloadPage = "https://berkeleygraphics.com/accounts/";
                    license = licenses.unfree;
                    platforms = [ "aarch64-linux" "i686-linux" "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
                };
            }))
        ];

        fontconfig.defaultFonts.monospace = [ "Berkeley Mono" ];

        # localConf = builtins.writeFile "fonts.xml" /* xml */ ''
        #     <?xml version="1.0"?>
        #     <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
        #     <fontconfig>
        #         <match target="pattern">
        #         <test qual="any" name="family" compare="eq"><string>Berkeley Mono</string></test>
        #         <edit name="family" mode="assign" binding="same"><string>JuliaMono</string></edit>
        #         </match>
        #     </fontconfig>
        # '';
    };
}