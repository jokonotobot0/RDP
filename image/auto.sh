#!/bin/bash
#
#
echo "Pilih OS yang ingin anda install"
echo "	1) Windows 10"
# echo "	2) Windows 2016"
# echo "	3) Windows 2012"
# echo "	4) Windows 10"
# echo "	5) Windows 2022"
echo "	6) Pakai link gz mu sendiri"

read -p "Pilih [1]: " PILIHOS

IFACE="Ethernet Instance 0"

case "$PILIHOS" in
	1|"") PILIHOS="http://178.128.86.187/windows10.gz";;

	6) read -p "Masukkan Link GZ mu : " PILIHOS;;
	*) echo "pilihan salah"; exit;;
esac


PASSADMIN="Nixpoin.com123Qqs"

IP4=$(curl -4 -s icanhazip.com)
GW=$(ip route | awk '/default/ { print $3 }')


cat >/tmp/net.bat<<EOF
@ECHO OFF
cd.>%windir%\GetAdmin
if exist %windir%\GetAdmin (del /f /q "%windir%\GetAdmin") else (
echo CreateObject^("Shell.Application"^).ShellExecute "%~s0", "%*", "", "runas", 1 >> "%temp%\Admin.vbs"
"%temp%\Admin.vbs"
del /f /q "%temp%\Admin.vbs"
exit /b 2)


netsh -c interface ip set address name="$IFACE" source=static address=$IP4 mask=255.255.240.0 gateway=$GW
netsh -c interface ip add dnsservers name="$IFACE" address=1.1.1.1 index=1 validate=no
netsh -c interface ip add dnsservers name="$IFACE" address=8.8.4.4 index=2 validate=no


ECHO SELECT VOLUME=%%SystemDrive%% > "%SystemDrive%\diskpart.extend"
ECHO EXTEND >> "%SystemDrive%\diskpart.extend"
START /WAIT DISKPART /S "%SystemDrive%\diskpart.extend"


cd /d "%ProgramData%/Microsoft/Windows/Start Menu/Programs/Startup"

del "%~f0"
exit
EOF



wget --no-check-certificate -O- $PILIHOS | gunzip | dd of=/dev/vda bs=3M status=progress

mount.ntfs-3g /dev/vda2 /mnt
cd "/mnt/ProgramData/Microsoft/Windows/Start Menu/Programs/"
cd Start* || cd start*; \
cp -f /tmp/net.bat net.bat

echo 'Your server will turning off in 3 second'
sleep 3
poweroff
