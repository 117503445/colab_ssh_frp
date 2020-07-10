# colab 解锁 ssh 基于 frp

## 起因

Google Colab 是一个激动人心的计划。用户可以免费使用 远程服务器，包含 K80 显卡。但是 Google 只提供了类似于 Jupyter Notebook 的 Web 编辑器，使用体验很糟糕。但是 Google 没有提供像 百度 AI Studio 一样的终端功能，就很不爽。本文基于 frp 启用了 Google Colab 服务器的 ssh 功能。

## 项目地址

<https://github.com/117503445/colab_ssh_frp>

## 解决思路

第一步就是安装 sshd，并开启密码登录和公钥登录的选项。另一方面，Google Colab 的服务器处在内网环境中，需要进行端口转发。还需要另一个具有公网 ip 的服务器。

## frp 准备工作

请参阅这篇使用说明，非常简单。

<https://github.com/fatedier/frp/blob/master/README_zh.md#%E9%80%9A%E8%BF%87-ssh-%E8%AE%BF%E9%97%AE%E5%85%AC%E5%8F%B8%E5%86%85%E7%BD%91%E6%9C%BA%E5%99%A8>

公网 ip 服务器 我选择了 Google 云服务器（每年免费300美金优惠券），主机域名 ggtaiwanmini.117503445.top

在 frps.ini 中写入

```ini
[common]
bind_port = 7000
```

然后运行 frps （我使用了 Docker

## 破解脚本

网上的 Blog 比如 <https://blog.zyuzhi.me/2018/08/15/google-colab-gpu.html>

都是使用 Ngrok 的，但我不喜欢 Ngrok。

以下解锁脚本部分参考上述链接中的解锁脚本

```sh
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
```

然后访问 ggtaiwanmini.117503445.top:6000 就可以进行 ssh 连接了

别直接用我的地址 QAQ 可以修改 frpc.ini 中的地址，指向自己的 frps 服务器。
