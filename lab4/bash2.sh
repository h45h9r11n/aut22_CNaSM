#!bin/bash

iptables -F
iptables -L

iptables -t nat -A POSTROUTING -j SNAT --to-source 10.0.0.160

# Checking
iptables -L -t nat
ping 192.168.40.1
wireshark
