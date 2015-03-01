# 为 Master 安装 ansible
sudo yum install ansible -y
sudo mv /etc/ansible/hosts /etc/ansible/hosts_bak
sudo cp /vagrant/playbooks/inventory /etc/ansible/hosts -f
