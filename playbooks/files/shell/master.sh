# install ansible for master
sudo yum install ansible -y

# ansible inventory file
sudo cp /vagrant/playbooks/inventory /etc/ansible/hosts -f
