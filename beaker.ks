# Beaker is developed and tested on Red Hat Enterprise Linux 7, but any
# compatible distro should work as well.
url --url=http://mirror.centos.org/centos/7/os/x86_64/
repo --name=install --baseurl=http://mirror.centos.org/centos/7/os/x86_64/
repo --name=updates --baseurl=http://mirror.centos.org/centos/7/updates/x86_64/
repo --name=extras --baseurl=http://mirror.centos.org/centos/7/extras/x86_64/
repo --name=cr --baseurl=http://mirror.centos.org/centos/7/cr/x86_64/
repo --name=beaker-server --baseurl=http://beaker-project.org/yum/server/RedHatEnterpriseLinux7/

# The usual installation stuff. Beaker has no particular requirements here.
auth --useshadow --enablemd5
firewall --disable
firstboot --disable
clearpart --all --initlabel
part / --fstype=ext4 --size=2000 --grow
part /boot --fstype=ext4 --size=500
part swap --recommended
bootloader --location=mbr
text
keyboard us
network --hostname=beaker-test
lang en_US.UTF-8
timezone America/New_York
install
zerombr
poweroff

# The root password is `beaker`. You may want to change this.
rootpw --iscrypted $1$mF86/UHC$0siTuCcbOzXX5nOSdcsPG.

# For now, the Beaker server does not support running with SELinux enabled.
# Patches welcome.
selinux --disabled

# These are the basic requirements for running a Beaker server and lab.
%packages
beaker-server
beaker-lab-controller
autofs
mod_ssl
tftp-server
%end

%post
set -x -v
exec 1>/root/ks-post.log 2>&1

# Turn on some services which are needed.
systemctl enable httpd
systemctl enable tftp.socket

cat <<EOF >>/etc/motd
Welcome to Beaker!
EOF

# set repositories
cat <<EOF > /etc/yum.repos.d/install.repo
[install]
name = install
baseurl = http://mirror.centos.org/centos/7/os/x86_64/
enabled = 1
gpgcheck = 0
EOF

cat <<EOF > /etc/yum.repos.d/updates.repo
[updates]
name = updates
baseurl = http://mirror.centos.org/centos/7/updates/x86_64/
enabled = 1
gpgcheck = 0
EOF

cat <<EOF > /etc/yum.repos.d/extras.repo
[extras]
name = extras
baseurl = http://mirror.centos.org/centos/7/extras/x86_64/
enabled = 1
gpgcheck = 0
EOF

cat <<EOF > /etc/yum.repos.d/cr.repo
[cr]
name = cr
baseurl = http://mirror.centos.org/centos/7/cr/x86_64/
enabled = 1
gpgcheck = 0
EOF


# Set SSH key
mkdir -p /root/.ssh
cat >> /root/.ssh/authorized_keys <<"__EOF__"
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC4kp7PsdgJbMtWjhClWWgOW63u76PuhYOI2nj73gR9paub1EPukE3b60yZrt5MiUE/PislDwsKXE2FcoyHuQQ8W24FWdozaNMhX5B5mpCgBjXoCRInPkhE8DlkVcMYj8kK+0tln520Rg8jsN84bHHDOOUArlWLtAGnQk7N69vbr77DfjUxVBiHiUj9WoADrOfWmy5FvDpgM/CrmIX7TazgJWoB91n//grePp9nV65kchET2kfsUJ7o/rzSVW/a9xK3f8byRBjpD/Pwih6dFo6+qDV9WgaljFBzMSkGWf32BcSw6iLPbzPFPs0HL6ARxPRbzPczgqzMJdwJ2su4O76ckuRpgxsU3RAI37egBVcml6W+/+VYGTdk/TbsAZGUo/AYKGqfe6L/ZuLX7KxJl/uBRvozj/L28TWXw8mXfmeYNwwNez4AFX1PN8vLj5IMcEvWFXCSAcRVJxdAUsUtfGz1Dq3bPj8lDkES1+cGyzDzwj8fg+Zw/cFXyXWXsgu8ilk= jlvillal@linuxru.int.sodarock.com
__EOF__

%end
