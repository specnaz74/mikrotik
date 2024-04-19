# 2024-04-16 12:30:12 by RouterOS 7.14.2
# software id = 1ZSX-MTI8
#
# model = RB750GL
# serial number = 467A02257697
/interface bridge
add name=bridge vlan-filtering=yes
/interface vlan
add interface=bridge name=Hivatal vlan-id=10
add interface=bridge name=Kamera vlan-id=20
add interface=bridge name=Muvhaz vlan-id=14
/interface bridge port
add bridge=bridge interface=ether1
add bridge=bridge interface=ether2 pvid=10
add bridge=bridge interface=ether3 pvid=10
add bridge=bridge interface=ether4 pvid=20
add bridge=bridge interface=ether5 pvid=14
/ipv6 settings
set disable-ipv6=yes
/interface bridge vlan
add bridge=bridge tagged=ether1,bridge untagged=ether2,ether3 vlan-ids=10
add bridge=bridge tagged=ether1,bridge untagged=ether5 vlan-ids=14
add bridge=bridge tagged=ether1,bridge untagged=ether4 vlan-ids=20
/ip dhcp-client
add interface=Hivatal
add add-default-route=no interface=Kamera use-peer-dns=no use-peer-ntp=no
add add-default-route=no interface=Muvhaz use-peer-dns=no use-peer-ntp=no
/system clock
set time-zone-name=Europe/Budapest
/system identity
set name=RouterOS
/system note
set show-at-login=no
/tool romon
set enabled=yes
