#!bin/bash

iptables -F 
iptables -L

# Create new chains
iptables -N ATTACKED
iptables -N ATTK_CHECK

# Log packets
iptables -A ATTACKED -m limit --limit 5/min -j LOG --log-prefix "IPTABLES (Rule ATTACKED): " --log-level 7

# Drop all packets that have made it here and add IP to the banned list
iptables -A ATTACKED -m recent --set --name BANNED --rsource -j DROP

# Keep track of IPs (in file /proc/net/xt_recent/ATTK) to check for repeats 
iptables -A ATTK_CHECK -m recent --set --name ATTK --rsource

# If an IP has exceeded 5 checks in 10 minutes, treat it as an attack (goto the ATTACKED chain).
iptables -A ATTK_CHECK -m recent --update --seconds 600 --hitcount 5 --name ATTK --rsource -j ATTACKED

# All packets we are not treating as an attack, we will accept
iptables -A ATTK_CHECK -j ACCEPT

# Accept all input on the loopback interface 
iptables -A INPUT -i lo -j ACCEPT

# Accept packets from connections that have already been established
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Drop packets from IPs on the banned list
iptables -A INPUT -p tcp --dport 22 -m recent --update --seconds 3600 --name BANNED --rsource -j DROP

# For all new connections on the port 22, we are going to check
iptables -A INPUT -p tcp --dport 22 -m state --state NEW -j ATTK_CHECK

iptables -L

