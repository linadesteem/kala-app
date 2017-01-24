#!/bin/bash

PROJECT=$1
PROJECT_URL=$2

# Update the system.
apt update
apt upgrade -y

# This ubuntu box does not set the locale correctly, which was causing postgres
# to use LATIN1 as the encoding, not what we want. So manualy set things to UTF8
locale-gen en_US.UTF-8
cat > /etc/default/locale <<- EOM
#  File generated by update-locale
LC_ALL=en_US.UTF-8
LANG=en_US.UTF-8
EOM

# Install the needed packages
apt install -y accountsservice acl acpid adduser apparmor apport apport-symptoms apt apt-transport-https apt-utils at base-files base-passwd bash bash-completion bcache-tools bind9-host binutils bsdmainutils bsdutils btrfs-tools build-essential busybox-initramfs busybox-static byobu bzip2 ca-certificates cloud-guest-utils cloud-init cloud-initramfs-copymods cloud-initramfs-dyn-netconf comerr-dev command-not-found command-not-found-data console-setup console-setup-linux coreutils cpio cpp cpp-5 cron cryptsetup cryptsetup-bin curl dash dbus dctrl-tools debconf debconf-i18n debianutils dh-python diffutils distro-info-data dmeventd dmidecode dmsetup dns-root-data dnsmasq-base dnsutils dosfstools dpkg dpkg-dev e2fslibs e2fsprogs eatmydata ed eject ethtool fakeroot file findutils fontconfig-config fonts-dejavu-core fonts-ubuntu-font-family-console friendly-recovery ftp fuse g++ g++-5 gawk gcc gcc-5 gcc-5-base gcc-6-base gdisk geoip-database gettext-base gir1.2-glib-2.0 git git-man gnupg gpgv grep groff-base grub-common grub-gfxpayload-lists grub-legacy-ec2 grub-pc grub-pc-bin grub2-common gzip hdparm hostname ifenslave ifupdown info init init-system-helpers initramfs-tools initramfs-tools-bin initramfs-tools-core initscripts insserv install-info iproute2 iptables iputils-ping iputils-tracepath irqbalance isc-dhcp-client isc-dhcp-common iso-codes kbd keyboard-configuration klibc-utils kmod krb5-locales krb5-multidev language-selector-common less libaccountsservice0 libacl1 libalgorithm-diff-perl libalgorithm-diff-xs-perl libalgorithm-merge-perl libapparmor-perl libapparmor1 libapt-inst2.0 libapt-pkg5.0 libasan2 libasn1-8-heimdal libasprintf0v5 libatm1 libatomic1 libattr1 libaudit-common libaudit1 libbind9-140 libblkid1 libbsd0 libbz2-1.0 libc-bin libc-dev-bin libc6 libc6-dev libcap-ng0 libcap2 libcap2-bin libcc1-0 libcilkrts5 libcomerr2 libcryptsetup4 libcurl3-gnutls libdb5.3 libdbus-1-3 libdbus-glib-1-2 libdebconfclient0 libdevmapper-event1.02.1 libdevmapper1.02.1 libdns-export162 libdns162 libdpkg-perl libdrm2 libdumbnet1 libeatmydata1 libedit2 libelf1 liberror-perl libestr0 libevent-2.0-5 libexpat1 libexpat1-dev libfakeroot libfdisk1 libffi6 libfile-fcntllock-perl libfontconfig1 libfreetype6 libfribidi0 libfuse2 libgcc-5-dev libgcc1 libgcrypt20 libgd3 libgdbm3 libgeoip1 libgirepository-1.0-1 libglib2.0-0 libglib2.0-data libgmp10 libgnutls-openssl27 libgnutls30 libgomp1 libgpg-error0 libgpm2 libgssapi-krb5-2 libgssapi3-heimdal libgssrpc4 libhcrypto4-heimdal libheimbase1-heimdal libheimntlm0-heimdal libhogweed4 libhx509-5-heimdal libice6 libicu55 libidn11 libisc-export160 libisc160 libisccc140 libisccfg140 libisl15 libitm1 libjansson4 libjbig0 libjpeg-turbo8 libjpeg8 libjson-c2 libk5crypto3 libkadm5clnt-mit9 libkadm5srv-mit9 libkdb5-8 libkeyutils1 libklibc libkmod2 libkrb5-26-heimdal libkrb5-3 libkrb5support0 libldap-2.4-2 liblocale-gettext-perl liblsan0 liblvm2app2.2 liblvm2cmd2.02 liblwres141 liblxc1 liblz4-1 liblzma5 liblzo2-2 libmagic1 libmatheval1 libmnl0 libmount1 libmpc3 libmpdec2 libmpfr4 libmpx0 libmspack0 libncurses5 libncursesw5 libnetfilter-conntrack3 libnettle6 libnewt0.52 libnfnetlink0 libnih1 libnuma1 libp11-kit0 libpam-modules libpam-modules-bin libpam-runtime libpam-systemd libpam0g libparted2 libpcap0.8 libpci3 libpcre3 libperl5.22 libpipeline1 libplymouth4 libpng12-0 libpolkit-agent-1-0 libpolkit-backend-1-0 libpolkit-gobject-1-0 libpopt0 libpq-dev libpq5 libprocps4 libpython-all-dev libpython-dev libpython-stdlib libpython2.7 libpython2.7-dev libpython2.7-minimal libpython2.7-stdlib libpython3-dev libpython3-stdlib libpython3.5 libpython3.5-dev libpython3.5-minimal libpython3.5-stdlib libquadmath0 libreadline5 libreadline6 libroken18-heimdal librtmp1 libsasl2-2 libsasl2-modules libsasl2-modules-db libseccomp2 libselinux1 libsemanage-common libsemanage1 libsensors4 libsepol1 libsigsegv2 libslang2 libsm6 libsmartcols1 libsodium18 libsqlite3-0 libss2 libssl-dev libssl-doc libssl1.0.0 libstdc++-5-dev libstdc++6 libsystemd0 libtasn1-6 libtext-charwidth-perl libtext-iconv-perl libtext-wrapi18n-perl libtiff5 libtinfo5 libtsan0 libubsan0 libudev1 libusb-0.1-4 libusb-1.0-0 libustr-1.0-1 libutempter0 libuuid1 libvpx3 libwind0-heimdal libwrap0 libx11-6 libx11-data libxau6 libxcb1 libxdmcp6 libxext6 libxml2 libxmu6 libxmuu1 libxpm4 libxslt1.1 libxt6 libxtables11 libyaml-0-2 libzmq5 linux-libc-dev linux-virtual locales login logrotate lsb-base lsb-release lshw lsof ltrace lvm2 lxc-common lxcfs lxd lxd-client make makedev man-db manpages manpages-dev mawk mdadm mime-support mlocate mount mtr-tiny multiarch-support nano ncurses-base ncurses-bin ncurses-term net-tools netbase netcat-openbsd nginx nginx-common nginx-core ntfs-3g open-iscsi open-vm-tools openssh-client openssh-server openssh-sftp-server openssl os-prober overlayroot parted passwd pastebinit patch pciutils perl perl-base perl-modules-5.22 plymouth plymouth-theme-ubuntu-text policykit-1 pollinate popularity-contest postgresql postgresql-9.5 postgresql-client-9.5 postgresql-client-common postgresql-common postgresql-contrib-9.5 postgresql-server-dev-9.5 postgresql-server-dev-all powermgmt-base procps psmisc python python-all python-all-dev python-apt-common python-dev python-minimal python-pip python-pip-whl python-pkg-resources python-setuptools python-wheel python2.7 python2.7-dev python2.7-minimal python3 python3-apport python3-apt python3-blinker python3-cffi-backend python3-chardet python3-commandnotfound python3-configobj python3-cryptography python3-dbus python3-debian python3-dev python3-distupgrade python3-gdbm python3-gi python3-idna python3-jinja2 python3-json-pointer python3-jsonpatch python3-jwt python3-markupsafe python3-minimal python3-newt python3-oauthlib python3-pip python3-pkg-resources python3-prettytable python3-problem-report python3-pyasn1 python3-pycurl python3-requests python3-serial python3-setuptools python3-six python3-software-properties python3-systemd python3-update-manager python3-urllib3 python3-wheel python3-yaml python3.5 python3.5-dev python3.5-minimal readline-common rename resolvconf rsync rsyslog run-one screen sed sensible-utils sgml-base shared-mime-info snap-confine snapd software-properties-common sosreport squashfs-tools ssh-import-id ssl-cert strace sudo sysstat systemd systemd-sysv sysv-rc sysvinit-utils tar tcpd tcpdump telnet time tmux tzdata ubuntu-cloudimage-keyring ubuntu-core-launcher ubuntu-keyring ubuntu-minimal ubuntu-release-upgrader-core ubuntu-server ubuntu-standard ucf udev ufw uidmap unattended-upgrades update-manager-core update-notifier-common ureadahead usbutils util-linux uuid-runtime uwsgi uwsgi-core uwsgi-plugin-python3 vim vim-common vim-runtime vim-tiny vlan wget whiptail x11-common xauth xclip xdg-user-dirs xfsprogs xkb-data xml-core xz-utils zerofree zlib1g zlib1g-dev zsh zsh-common zsh-dev

# If oh-my-zsh is not installed the install it.
if [ ! -f /home/vagrant/.zshrc ]; then
	git clone git://github.com/robbyrussell/oh-my-zsh.git /home/vagrant/.oh-my-zsh
	cp /home/vagrant/.oh-my-zsh/templates/zshrc.zsh-template /home/vagrant/.zshrc
	chsh -s /bin/zsh vagrant
fi

# Clear out the nginx config if needed
if [ -f /etc/nginx/sites-available/default ]; then
    rm /etc/nginx/sites-enabled/default
    rm /etc/nginx/sites-available/default
fi

# Clear out the uwsgi config if needed
if [ -f /etc/uwsgi/apps-available/README ]; then
    rm /etc/uwsgi/apps-enabled/README
    rm /etc/uwsgi/apps-available/README
fi

# Create the nginx conf
cat > /etc/nginx/sites-available/$PROJECT_URL.conf <<- EOM
server {
    listen   80;

    charset utf-8;
    server_name $PROJECT_URL;
    access_log /var/log/nginx/$PROJECT_URL.access.log;
    error_log /var/log/nginx/$PROJECT_URL.error.log;
    client_max_body_size 200M;

    location / {
        uwsgi_pass unix:/run/uwsgi/app/$PROJECT_URL/socket;
        include    uwsgi_params;
    }

    location /static/ {
            alias /srv/$PROJECT-app/$PROJECT/$PROJECT/static/;
    }

    location /media/ {
            alias /srv/$PROJECT-app/$PROJECT/$PROJECT/media/;
    }
}
EOM

# If the symbolic link exists, remove it.
if [ -f /etc/nginx/sites-enabled/$PROJECT_URL.conf ]; then
    rm /etc/nginx/sites-enabled/$PROJECT_URL.conf
fi
ln -s /etc/nginx/sites-available/$PROJECT_URL.conf /etc/nginx/sites-enabled/$PROJECT_URL.conf

# Create the uwsgi conf
cat > /etc/uwsgi/apps-available/$PROJECT_URL.ini <<- EOM
[uwsgi]
vhost = true
plugins = python3
master = true
enable-threads = true
processes = 2
chdir = /srv/$PROJECT-app/$PROJECT
module = $PROJECT.wsgi:application
touch-reload = /srv/$PROJECT-app/reload
virtualenv = /home/vagrant/.virtualenvs/$PROJECT

env = DEPLOYMENT_ENVIRONMENT=development
env = DATABASE_USER=ndptc
env = DATABASE_PASSWORD=ndptc
env = DATABASE_NAME=ndptc
EOM

# zshrc
cat >> /home/vagrant/.zshrc <<- EOM
export DEPLOYMENT_ENVIRONMENT=development
export DATABASE_USER=ndptc
export DATABASE_PASSWORD=ndptc
export DATABASE_NAME=ndptc
source /home/vagrant/.virtualenvs/$PROJECT/bin/activate
cd /srv/$PROJECT-app/$PROJECT
EOM

# If the symbolic link exists, remove it.
if [ -f /etc/uwsgi/apps-enabled/$PROJECT_URL.ini ]; then
    rm /etc/uwsgi/apps-enabled/$PROJECT_URL.ini
fi
ln -s /etc/uwsgi/apps-available/$PROJECT_URL.ini /etc/uwsgi/apps-enabled/$PROJECT_URL.ini

# Create the database, check if the role and database exist first though.
if ! sudo -u postgres -- psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='ndptc'" | grep -q 1; then
	sudo -u postgres -- psql -c "CREATE ROLE ndptc WITH LOGIN PASSWORD 'ndptc';"
fi

if ! sudo -u postgres -- psql -tAc "SELECT 1 from pg_database WHERE datname='ndptc'"  | grep -q 1; then
	sudo -u postgres -- psql -c "CREATE DATABASE ndptc WITH OWNER ndptc;"
fi

# Make it so pip does not complain if pip is an older version.
pip install -U pip

# Create the virtualenv
pip install virtualenv
virtualenv -p /usr/bin/python3 /home/vagrant/.virtualenvs/$PROJECT
source /home/vagrant/.virtualenvs/$PROJECT/bin/activate
pip install -r /srv/$PROJECT-app/requirements-dev.txt
chown -R vagrant:vagrant /home/vagrant/.virtualenvs/$PROJECT

# Migrate the database
source /home/vagrant/.zshrc
cd /srv/$PROJECT-app/$PROJECT
python3 manage.py migrate

# Restart the services
systemctl restart uwsgi.service
systemctl restart nginx.service
