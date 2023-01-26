
/ip firewall filter
add action=accept chain=input comment="accept established,related,untracked" \
    connection-state=established,related,untracked
add action=drop chain=input comment="drop invalid" connection-state=invalid
add action=accept chain=input comment="accept ICMP" protocol=icmp
add action=accept chain=input comment=winbox dst-port=8291 protocol=tcp
add action=accept chain=input comment=\
    "accept to local loopback (for CAPsMAN)" dst-address=127.0.0.1
add action=drop chain=input comment="drop all not coming from LAN" \
    in-interface=!bridge
add action=accept chain=forward comment="accept in ipsec policy" \
    ipsec-policy=in,ipsec
add action=accept chain=forward comment="accept out ipsec policy" \
    ipsec-policy=out,ipsec
add action=fasttrack-connection chain=forward comment=fasttrack \
    connection-state=established,related disabled=yes
add action=accept chain=forward comment=\
    "accept established,related, untracked" connection-state=\
    established,related,untracked
add action=drop chain=forward comment="drop invalid" connection-state=invalid
add action=drop chain=forward comment="drop all from WAN not DSTNATed" \
    connection-nat-state=!dstnat connection-state=new in-interface=ether1
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1
/caps-man channel
add band=2ghz-b/g/n control-channel-width=20mhz frequency=2412 name=channel01
add band=2ghz-b/g/n control-channel-width=20mhz frequency=2437 name=channel06
add band=2ghz-b/g/n control-channel-width=20mhz frequency=2462 name=channel11
add band=2ghz-b/g/n control-channel-width=20mhz frequency=2417 name=channel02
add band=2ghz-b/g/n control-channel-width=20mhz frequency=2422 name=channel03
add band=2ghz-b/g/n control-channel-width=20mhz frequency=2427 name=channel04
add band=2ghz-b/g/n control-channel-width=20mhz frequency=2432 name=channel05
add band=2ghz-b/g/n control-channel-width=20mhz frequency=2442 name=channel07
add band=2ghz-b/g/n control-channel-width=20mhz frequency=2447 name=channel08
add band=2ghz-b/g/n control-channel-width=20mhz frequency=2452 name=channel09
add band=2ghz-b/g/n control-channel-width=20mhz frequency=2457 name=channel10
add band=2ghz-b/g/n control-channel-width=20mhz frequency=2467 name=channel12
add band=2ghz-b/g/n control-channel-width=20mhz frequency=2472 name=channel13
add band=2ghz-b/g/n control-channel-width=20mhz frequency=2484 name=channel14
/system clock
set time-zone-name=Europe/Budapest
/system ntp client
set enabled=yes
/system ntp client servers
add address=212.92.16.193
add address=91.121.7.182
/ipv6 settings
set disable-ipv6=yes
