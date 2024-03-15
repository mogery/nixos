{ pkgs, ... }:

{
    home.packages =
        let
            daytona = with pkgs; stdenvNoCC.mkDerivation (finalAttrs: {
                pname = "daytona-bin";
                version = "0.3.1";

                src =
                    let
                        urls = {
                            "x86_64-linux" = {
                            url = "https://download.daytona.io/daytona/v${finalAttrs.version}/daytona-linux-amd64";
                            hash = "sha256-IPTU0Jqq8SBtyCtcQgc3ZiBWBDJSczQUNw5LMrsqC3k=";
                            };
                            "x86_64-darwin" = {
                            url = "https://download.daytona.io/daytona/v${finalAttrs.version}/daytona-darwin-amd64";
                            hash = "sha256-eR3DmbOTJsvD3W4Fqa8x/TBZlYHP/6YZoGrwJ+jGwUs=";
                            };
                            "aarch64-linux" = {
                            url = "https://download.daytona.io/daytona/v${finalAttrs.version}/daytona-linux-arm64";
                            hash = "sha256-Yz5EikYRt8jOADDjsMDElr3H5RoiXtxM6R+vLKxkgy0=";
                            };
                            "aarch64-darwin" = {
                            url = "https://download.daytona.io/daytona/v${finalAttrs.version}/daytona-darwin-arm64";
                            hash = "sha256-CJewbCx8ZGaW7GLdmZCCFD7kdDBdyH/eSR8LgC/Zavs=";
                            };
                        };
                    in
                        fetchurl urls."${stdenvNoCC.hostPlatform.system}";

                dontUnpack = true;

                installPhase = ''
                    runHook preInstall
                    mkdir -p $out/bin
                    cp -r $src $out/bin/daytona
                    chmod +x $out/bin/daytona
                    runHook postInstall
                '';

                meta = {
                    changelog = "https://github.com/daytonaio/daytona/releases/tag/v${finalAttrs.version}";
                    description = "The Open Source Dev Environment Manager";
                    homepage = "https://github.com/daytonaio/daytona";
                    license = lib.licenses.asl20;
                    mainProgram = "daytona";
                    maintainers = with lib.maintainers; [ ];
                    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
                };
            });
        in
        [ daytona ];
}