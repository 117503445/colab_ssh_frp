import random, string, urllib.request, json

#root password
password = '12345678'

#Setup sshd
! apt-get install -qq -o=Dpkg::Use-Pty=0 openssh-server pwgen > /dev/null

#Set root password
! echo root:$password | chpasswd
! mkdir -p /var/run/sshd
! echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
! echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
! echo "RSAAuthentication yes" >> /etc/ssh/sshd_config
! echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
! echo "AuthorizedKeysFile .ssh/authorized_keys" >> /etc/ssh/sshd_config

! echo "LD_LIBRARY_PATH=/usr/lib64-nvidia" >> /root/.bashrc
! echo "export LD_LIBRARY_PATH" >> /root/.bashrc

#Run sshd
get_ipython().system_raw('/usr/sbin/sshd -D &')

!wget https://raw.githubusercontent.com/117503445/colab_ssh_frp/master/frpc.ini
!wget https://raw.githubusercontent.com/117503445/colab_ssh_frp/master/frpc
!chmod +x frpc

!./frpc