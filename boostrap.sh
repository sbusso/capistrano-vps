# postinstall.sh

date > /etc/box_build_time


# Apt-install various things necessary for Ruby, guest additions,
# etc., and remove optional things to trim down the machine.
apt-get -y update
apt-get -y upgrade
apt-get -y install linux-headers-$(uname -r) build-essential
apt-get -y install zlib1g-dev libssl-dev libreadline-gplv2-dev
apt-get -y install nano htop
apt-get clean

# Setup sudo to allow no-password sudo for "admin"
groupadd -r admin
useradd -d /home/deployer --password rUCqgryF5fqKM --groups admin -m deployer
usermod -s /bin/bash deployer
cp /etc/sudoers /etc/sudoers.orig
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=admin' /etc/sudoers
sed -i -e 's/%admin ALL=(ALL) ALL/%admin ALL=(ALL) NOPASSWD: ALL/g' /etc/sudoers


# Installing ssh keys
mkdir /home/deployer/.ssh
chmod 700 /home/deployer/.ssh
cd /home/deployer/.ssh
wget --no-check-certificate 'https://raw.github.com/sbusso/my_files/master/id_rsa.pub' -O authorized_keys
chmod 600 /home/deployer/.ssh/authorized_keys
chown -R deployer /home/deployer/.ssh

# Remove items used for building, since they aren't needed anymore
# apt-get -y remove linux-headers-$(uname -r) build-essential
# apt-get -y autoremove

# Zero out the free space to save space in the final image:
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# Removing leftover leases and persistent rules
echo "cleaning up dhcp leases"
rm /var/lib/dhcp3/*

# Make sure Udev doesn't block our network
# http://6.ptmc.org/?p=164
echo "cleaning up udev rules"
rm /etc/udev/rules.d/70-persistent-net.rules
mkdir /etc/udev/rules.d/70-persistent-net.rules
rm -rf /dev/.udev/
rm /lib/udev/rules.d/75-persistent-net-generator.rules

echo "Adding a 2 sec delay to the interface up, to make the dhclient happy"
echo "pre-up sleep 2" >> /etc/network/interfaces
exit
