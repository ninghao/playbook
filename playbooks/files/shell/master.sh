# 为 Master 安装 ansible
sudo yum install ansible -y

# 复制 inventory 到 Master 上
# 这个文件里面是可以使用 ansible 控制的主机，默认这里包含 local 与 dev 这两台主机。
sudo cp /vagrant/playbooks/inventory /etc/ansible/hosts -f
