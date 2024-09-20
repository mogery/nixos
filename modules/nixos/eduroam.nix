{
  environment.etc."NetworkManager/system-connections/eduroam.nmconnection".text = ''
    [connection]
    id=eduroam
    uuid=bec5ee7c-73ef-41b3-80bb-ba19276f44e3
    type=wifi
    timestamp=1726824080

    [wifi]
    mode=infrastructure
    ssid=eduroam

    [wifi-security]
    auth-alg=open
    key-mgmt=wpa-eap

    [802-1x]
    anonymous-identity=anonymous@edu.hu
    eap=external;peap;
    identity=moriczg@illyes-bors.edu.hu
    password-flags=2
    phase2-auth=mschapv2
    private-key-password-flags=2

    [ipv4]
    method=auto

    [ipv6]
    addr-gen-mode=default
    method=auto

    [proxy]
  '';
}
