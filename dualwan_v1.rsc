/ip dhcp-client
add add-default-route=no disabled=no interface=ether1
add add-default-route=no disabled=no interface=ether2
/ip firewall mangle
add action=mark-connection chain=prerouting in-interface=ether1 \
    new-connection-mark=ether1_connection
add action=mark-connection chain=prerouting in-interface=ether2 \
    new-connection-mark=ether2_connection
add action=mark-routing chain=prerouting connection-mark=ether1_connection \
    in-interface=bridge1 new-routing-mark=to_ether1
add action=mark-routing chain=prerouting connection-mark=ether2_connection \
    in-interface=bridge1 new-routing-mark=to_ether2
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1
add action=masquerade chain=srcnat out-interface=ether2
/ip route
add distance=1 gateway=ether1 routing-mark=to_ether1
add distance=1 gateway=ether2 routing-mark=to_ether2
add comment=WAN1 distance=1 gateway=ether1
add distance=2 gateway=ether2
/system scheduler
add disabled=yes interval=30m name="WAN1 Route enable" on-event=":log info \"W\
    AN1 - check!\"\r\
    \nip route set [find comment=\"WAN1\"] disabled=no" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=mar/28/2021 start-time=08:00:00
add disabled=yes interval=20h name="Send SMS" on-event="/tool sms send usb1 ph\
    one-number=\"+36705370954\" channel=1 message=\"WAN1 down!\" smsc=\"+36309\
    888000\"" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=mar/28/2021 start-time=14:12:24
add interval=5m name="WAN1 Check" on-event=dualwan policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=mar/28/2021 start-time=08:00:00
add name="After Reboot" on-event=\
    ":delay 5s\r\
    \nip route set [find comment=\"WAN1\"] disabled=no" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-time=startup
/system script
add dont-require-permissions=no name=dualwan owner=jszfadmin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="#\
    \_This is Mikrotik Script for Local Device Link monitoring by IP\r\
    \n# - with Optional SMS Alert. We are using local Linux base KANNEL\r\
    \n# You can modify it to add EMAIL alerts as well using GMAIL or local Mai\
    l Gw.\r\
    \n# system as SMS gateway with local modem attached\r\
    \n# Script By Syed Jahanzaib / # https://aacable.wordpress.com\r\
    \n# Email : aacable at hotmail dot com\r\
    \n# Script Last Modified : 26-July-2017\r\
    \n \r\
    \n# Set Device IP here\r\
    \n:local DEVICE1host1 \"8.8.8.8\"\r\
    \n# Dont use SPACEC Here, because our KANNEL system dont like spaces, use \
    + sign instead\r\
    \n:local DEVNAME \"WAN1\"\r\
    \n:global DEVICE1LanStatus;\r\
    \n:global DEVICE1LanLastChange;\r\
    \n \r\
    \n#:log warning \"Checking status of Device \$DEVICE1host1 by ping ...\"\r\
    \n:local DELAY \"3s\"\r\
    \n:local i 0;\r\
    \n:local F 0;\r\
    \n:local date;\r\
    \n:local time;\r\
    \n:set date [/system clock get date];\r\
    \n:set time [/system clock get time];\r\
    \n# Setting Date Time variables\r\
    \n:local sub1 ([/system identity get name])\r\
    \n:local sub2 ([/system clock get date])\r\
    \n:local sub3 ([/system clock get time])\r\
    \n \r\
    \n# Company Name, Dont use SPACEC Here, because our KANNEL system dont lie\
    k spaces, use + sign instead\r\
    \n:local COMPANY \"Jaszfenyszaru\"\r\
    \n \r\
    \n# Number of Ping Count, how many times mikrotik should ping the target d\
    evice\r\
    \n:local PINGCOUNT \"5\"\r\
    \n# Ping threshold\r\
    \n:local PINGTS \"5\"\r\
    \n \r\
    \n# Mail Alert information\r\
    \n:local ADMINMAIL1 \"info@fenyszaru.hu\"\r\
    \n \r\
    \n# LOG error\r\
    \n:local DOWNLOG1 \"\$COMPANY ALERT: \$DEVNAME with IP \$DEVICE1host1 is n\
    ow DOWN @ \$sub1 \$sub2 \$sub3...\"\r\
    \n:local UPLOG1 \"\$COMPANY INFO: \$DEVNAME with IP \$DEVICE1host1 is now \
    UP @ \$sub1 \$sub2 \$sub3 ...\"\r\
    \n \r\
    \n# Start the SCRIPT\r\
    \n# DONOT EDIT BELOW\r\
    \n \r\
    \n# If Script is running for the first time , consider target device UP,\r\
    \n# Just to avoid any errors in the script dueto empty variable.\r\
    \n:if ([:len \$DEVICE1LanStatus] = 0) do={\r\
    \n:set DEVICE1LanStatus \"UP\";\r\
    \n}\r\
    \n \r\
    \n# PING each host \$PINGCOUNT times\r\
    \n# IF NOT A SINGLE PING SUCCESSFULL THEN CONSIDER LINK DOWN ## ZAIB\r\
    \n/ip route set [find comment=\"WAN1\"] disabled=no \r\
    \n:for i from=1 to=\$PINGCOUNT do={\r\
    \nif ([/ping \$DEVICE1host1 interface=ether1 count=1]=0) do={:set F (\$F +\
    \_1)}\r\
    \n:delay 1;\r\
    \n};\r\
    \n \r\
    \n# If no response (all ping counts fails for both hosts, Time out, then L\
    OG down status and take action\r\
    \n:if ((\$F=\$PINGTS)) do={\r\
    \n:if ((\$DEVICE1LanStatus=\"UP\")) do={\r\
    \n \r\
    \n# If the link is down, then LOG warning in Mikrotik LOG window [Zaib]\r\
    \n:log error \"\$DOWNLOG1\";\r\
    \n:set DEVICE1LanStatus \"DOWN\";\r\
    \n/ip route set [find comment=\"WAN1\"] disabled=yes;\r\
    \n# Also add status in global variables to be used as tracking\r\
    \n:set date [/system clock get date];\r\
    \n:set time [/system clock get time];\r\
    \n:set DEVICE1LanLastChange (\$time . \" \" . \$date);\r\
    \n# Send SMS for DOWN Status\r\
    \n:log warning \"Sending EMAIL/SMS for DOWN status of \$DEVNAME \$DEVICE1h\
    ost1 ...\"\r\
    \n#/tool sms send usb1 phone-number=\"+36705370954\" channel=1 message=\"\
    \$DEVNAME \$DEVICE1host1 is now DOWN @ \$sub3 \$sub2 \$sub1\" smsc=\"+3630\
    9888000\"\r\
    \n/tool e-mail send to=\$ADMINMAIL1 subject=\"\$COMPANY ALERT: \$DEVNAME \
    \$DEVICE1host1 is now DOWN @ \$sub3 \$sub2 \$sub1\" start-tls=yes\r\
    \n\r\
    \n#/interface ether1 disable;\r\
    \n#:delay \$DELAY\r\
    \n#/interface sfp1 enable;\r\
    \n \r\
    \n######################\r\
    \n# ADD YOUR CUSTOMIZED ACTION HERE LIKE CHANGE ROUTE OR DISABL/ENABLE ANY\
    \_THING\r\
    \n######################\r\
    \n# If ping reply received, then LOG UP and take action as required\r\
    \n} else={:set DEVICE1LanStatus \"DOWN\"; /ip route set [find comment=\"WA\
    N1\"] disabled=yes;}\r\
    \n} else={\r\
    \n:if ((\$DEVICE1LanStatus=\"DOWN\")) do={\r\
    \n# If link is UP, then LOG info and warning in Mikrotik LOG window [Zaib]\
    \r\
    \n:log warning \"\$UPLOG1\"\r\
    \n:set DEVICE1LanStatus \"UP\";\r\
    \n \r\
    \n# Send SMS for UP Status\r\
    \n:set date [/system clock get date];\r\
    \n:set time [/system clock get time];\r\
    \n:set DEVICE1LanLastChange (\$time . \" \" . \$date);\r\
    \n:log warning \"Sending EMAIL/SMS for UP status of \$DEVNAME \$DEVICE1hos\
    t1 ...\"\r\
    \n:delay 10s\r\
    \n#/tool sms send usb1 phone-number=\"+36705370954\" channel=1 message=\"\
    \$DEVNAME \$DEVICE1host1 is now UP @ \$sub3 \$sub2 \$sub1\" smsc=\"+363098\
    88000\"\r\
    \n/tool e-mail send to=\$ADMINMAIL1 subject=\"\$COMPANY INFO: \$DEVNAME \$\
    DEVICE1host1 is now UP @ \$sub3 \$sub2 \$sub1\" start-tls=yes\r\
    \n# ADD YOUR CUSTOMIZED ACTION HERE LIKE CHANGE ROUTE OR DISABL/ENABLE ANY\
    \_THING LIKE\r\
    \n#/ip route set [find comment=\"WAN1\"] disabled=yes;\r\
    \n#/interface ether1 disable;\r\
    \n#:delay \$DELAY\r\
    \n#/interface sfp1 enable;\r\
    \n} else={:set DEVICE1LanStatus \"UP\";}\r\
    \n}\r\
    \n# Script ends here ..."
