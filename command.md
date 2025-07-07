## Commande pour installer terraform sur alma

sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo

sudo dnf install terraform