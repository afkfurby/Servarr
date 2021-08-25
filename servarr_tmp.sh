echo '{"pkgs":["ca_root_nss","llvm80","libepoxy-1.5.2"]}' > /tmp/pkg.json
iocage create -n jackett -p /tmp/pkg.json -r 12.2-RELEASE dhcp="on" vnet="on" bpf="yes" boot="on"
rm /tmp/pkg.json
iocage exec jackett "fetch 'https://bugs.freebsd.org/bugzilla/attachment.cgi?id=211960' -o /tmp/mono-patch-6.8.0.105"
iocage exec jackett "mkdir -p /usr/local/etc/pkg/repos"
iocage exec jackett "echo -e 'FreeBSD: { url: \"pkg+http://pkg.FreeBSD.org/\${ABI}/latest\" }' > /usr/local/etc/pkg/repos/FreeBSD.conf"
iocage exec jackett "pkg update"
iocage exec jackett "pkg upgrade -y"
iocage exec jackett "portsnap fetch extract"
iocage exec jackett "echo -e 'cd /usr/ports/lang' > /tmp/jackett.sh"
iocage exec jackett "echo -e 'cp -R mono mono68105' >> /tmp/jackett.sh"
iocage exec jackett "echo -e 'patch -E < /tmp/mono-patch-6.8.0.105' >> /tmp/jackett.sh"
iocage exec jackett "echo -e 'cd /usr/ports/lang/mono' >> /tmp/jackett.sh"
iocage exec jackett "echo -e 'make -DBATCH install' >> /tmp/jackett.sh"
iocage exec jackett "echo -e 'make -DBATCH package' >> /tmp/jackett.sh"
iocage exec jackett "echo -e 'mv /usr/ports/lang/mono/work/pkg/mono-6.8.0.105.txz /' >> /tmp/jackett.sh"
iocage exec jackett "sh /tmp/jackett.sh"




pkg install ca_root_nss llvm80 libepoxy

fetch 'https://bugs.freebsd.org/bugzilla/attachment.cgi?id=211960' -o /tmp/mono-patch-6.8.0.105
mkdir -p /usr/local/etc/pkg/repos
echo -e 'FreeBSD: { url: \"pkg+http://pkg.FreeBSD.org/\${ABI}/latest\" }' > /usr/local/etc/pkg/repos/FreeBSD.conf
pkg update
pkg upgrade -y
portsnap fetch extract
echo -e 'cd /usr/ports/lang' > /tmp/mono_upgrade.sh

echo -e 'cp -R mono mono68105' >> /tmp/mono_upgrade.sh
echo -e 'patch -E < /tmp/mono-patch-6.8.0.105' >> /tmp/mono_upgrade.sh
echo -e 'cd /usr/ports/lang/mono' >> /tmp/mono_upgrade.sh
echo -e 'make -DBATCH install' >> /tmp/mono_upgrade.sh
echo -e 'make -DBATCH package' >> /tmp/mono_upgrade.sh
echo -e 'mv /usr/ports/lang/mono/work/pkg/mono-6.8.0.105.txz /' >> /tmp/mono_upgrade.sh
sh /tmp/jackett.mono_upgrade


mono --version
pkg lock -y radarr sonarr lidarr
fetch https://github.com/jailmanager/jailmanager.github.io/releases/download/v0.0.1/mono-6.8.0.105.txz
pkg install -y mono-6.8.0.105.txz
pkg unlock -y radarr sonarr lidarr

####
https://github.com/afkfurby/Servarr
https://www.truenas.com/community/threads/how-to-install-and-configure-sonarr-radarr-transmission-and-sabnzbd-11-3-u3-2.86031/
https://daulton.ca/2018/12/radarr-on-freebsd/
https://github.com/truecharts/jailmanager.github.io/releases
https://www.reddit.com/r/freenas/comments/jkes3i/truenas_12_jails_and_mono_jackett_radarr_sonarr/
https://www.truenas.com/community/threads/how-to-manually-upgrade-mono-from-5-10-to-5-20-in-a-freenas-jail.78871/post-632438

dotnet install
https://www.truenas.com/community/threads/experimental-radarr-v3-2-dotnet5-binary.91489/
##

pkg update
pkg upgrade
pkg install -y nano

# install arr apps
pkg install -y radarr sonarr lidarr

# upgrade mono
mono --version
pkg lock -y radarr sonarr lidarr
fetch https://github.com/jailmanager/jailmanager.github.io/releases/download/v0.0.1/mono-6.8.0.105.txz
pkg install -y mono-6.8.0.105.txz
pkg unlock -y radarr sonarr lidarr

# enable arr services
sysrc radarr_enable=YES
sysrc sonarr_enable=YES
sysrc lidarr_enable=YES

# start arr services
service radarr start
service sonarr start
service lidarr start

# stop arr services
service radarr onestop
service sonarr onestop
service lidarr onestop

# create user for accessing share and running services
pw useradd -n jailuser -u 900 -d /nonexistent -s /usr/sbin/nologin

# change service user
chown -R jailuser:jailuser /usr/local/radarr
sysrc 'radarr_user=jailuser'
chown -R jailuser:jailuser /usr/local/share/radarr
chown -R jailuser:jailuser /usr/local/sonarr
sysrc 'sonarr_user=jailuser'
chown -R jailuser:jailuser /usr/local/share/sonarr
chown -R jailuser:jailuser /usr/local/lidarr
sysrc 'lidarr_user=jailuser'
chown -R jailuser:jailuser /usr/local/share/lidarr

# start arr services
service radarr start
service sonarr start
service lidarr start


