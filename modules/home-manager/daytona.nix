{ pkgs, ... }:

{
    home.packages =
        let
            daytona = with pkgs; stdenvNoCC.mkDerivation (finalAttrs: {
                pname = "daytona-bin";
                version = "0.5.0";

                src =
                    let
                        urls = {
                            "x86_64-linux" = {
                                url = "https://download.daytona.io/daytona/v${finalAttrs.version}/daytona-linux-amd64";
                                sha256 = "14l8kimggi2vqspi7fx3dvdvdpj59i0bjicg904gs8kn8nwj3m1i";
                            };
                            "x86_64-darwin" = {
                                url = "https://download.daytona.io/daytona/v${finalAttrs.version}/daytona-darwin-amd64";
                                sha256 = "0gi9xci9cah5cwlnv73bhvk6zwhvvdb3nl338xf1fadwbx7dic6l";
                            };
                            "aarch64-linux" = {
                                url = "https://download.daytona.io/daytona/v${finalAttrs.version}/daytona-linux-arm64";
                                sha256 = "0ikbh424wx6qk3y63m2w7wf4mswcyclq7r7m285ax09wahpkz35s";
                            };
                            "aarch64-darwin" = {
                                url = "https://download.daytona.io/daytona/v${finalAttrs.version}/daytona-darwin-arm64";
                                sha256 = "12gn1qz3qgj5i1xkcylp7yz8frxnrlfhc0vygyj66wc9xqzv3m0m";
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