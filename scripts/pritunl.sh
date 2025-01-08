#!/bin/bash

# Adicionar repositório do MongoDB
sudo tee /etc/apt/sources.list.d/mongodb-org.list << EOF
deb [ signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse
EOF

# Adicionar repositório do OpenVPN
sudo tee /etc/apt/sources.list.d/openvpn.list << EOF
deb [ signed-by=/usr/share/keyrings/openvpn-repo.gpg ] https://build.openvpn.net/debian/openvpn/stable jammy main
EOF

# Adicionar repositório do Pritunl
sudo tee /etc/apt/sources.list.d/pritunl.list << EOF
deb [ signed-by=/usr/share/keyrings/pritunl.gpg ] https://repo.pritunl.com/stable/apt jammy main
EOF

# Instalar GNUPG para manipulação das chaves
sudo apt --assume-yes install gnupg

# Adicionar chaves para MongoDB, OpenVPN e Pritunl
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor --yes
curl -fsSL https://swupdate.openvpn.net/repos/repo-public.gpg | sudo gpg -o /usr/share/keyrings/openvpn-repo.gpg --dearmor --yes
curl -fsSL https://raw.githubusercontent.com/pritunl/pgp/master/pritunl_repo_pub.asc | sudo gpg -o /usr/share/keyrings/pritunl.gpg --dearmor --yes

# Atualizar lista de pacotes
sudo apt update

# Instalar Pritunl, OpenVPN, MongoDB, Wireguard e Wireguard-tools sem solicitar confirmação
sudo apt --assume-yes install pritunl openvpn mongodb-org wireguard wireguard-tools

# Desativar o firewall UFW
sudo ufw disable

# Iniciar e habilitar serviços para iniciar automaticamente
sudo systemctl start pritunl mongod
sudo systemctl enable pritunl mongod

# Ajustar limites de arquivos abertos
sudo sh -c 'echo "* hard nofile 64000" >> /etc/security/limits.conf'
sudo sh -c 'echo "* soft nofile 64000" >> /etc/security/limits.conf'
sudo sh -c 'echo "root hard nofile 64000" >> /etc/security/limits.conf'
sudo sh -c 'echo "root soft nofile 64000" >> /etc/security/limits.conf'