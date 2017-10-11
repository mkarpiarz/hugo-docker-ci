apt-get update
apt-get install software-properties-common -y
apt-add-repository ppa:ansible/ansible -y
apt-get update
apt-get install ansible -y

# Create a sudo user for Ansible
# First, create a privileged group
getent group bots || groupadd --gid 5000 bots
# Make sure the privileged group has sudo
SUDOERS_FILE=/etc/sudoers.d/10_bots
if [[ ! -e ${SUDOERS_FILE} ]]
then
cat << EOF > $SUDOERS_FILE
%bots ALL=(ALL) NOPASSWD: ALL
EOF
fi
# Create an user for ansible
getent passwd ansible || useradd --uid 5000 -c "Ansible user" -g bots --shell /bin/bash --create-home --home-dir /home/ansible --no-user-group ansible

# Add public key for the user
ANSIBLE_HOME=/home/ansible
[[ -d ${ANSIBLE_HOME}/.ssh ]] || mkdir ${ANSIBLE_HOME}/.ssh
cat ./keys/ansible_user_key.pub > ${ANSIBLE_HOME}/.ssh/authorized_keys
chown -R ansible:bots ${ANSIBLE_HOME}/.ssh/
chmod 700 ${ANSIBLE_HOME}/.ssh

# Make sure the ansible group is allowed to SSH
[[ -z $(grep "^AllowGroups.*bots" /etc/ssh/sshd_config) ]] && echo "AllowGroups bots" >> /etc/ssh/sshd_config
sshd -t && service ssh restart
