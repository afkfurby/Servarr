# install debootstrap for debian based jails


# enable pkg on truenas core
sed 's/enabled: yes/enabled: no/' /usr/local/etc/pkg/repos/local.conf
sed 's/enabled: no/enabled: yes/' /usr/local/etc/pkg/repos/FreeBSD.conf

pkg update
pkg -y install debootstrap

# create jails
https://iocage.readthedocs.io/en/latest/debian.html
https://forums.freebsd.org/threads/setting-up-a-debian-linux-jail-on-freebsd.68434/