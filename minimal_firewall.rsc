
/ip firewall filter
add action=accept chain=input comment="igmp proxy" protocol=igmp
add action=accept chain=forward comment="igmp proxy" protocol=igmp
add action=accept chain=input comment="igmp proxy" protocol=udp
add action=accept chain=forward comment="igmp proxy" protocol=udp
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
