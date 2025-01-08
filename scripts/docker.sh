#!/bin/bash
# Atualiza a lista de pacotes e instala as atualizações
sudo apt update -y && sudo apt upgrade -y

# Instala dependências necessárias
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Adiciona a chave GPG do repositório do Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Adiciona o repositório do Docker
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Atualiza a lista de pacotes novamente
sudo apt update -y

# Instala o Docker
sudo apt install -y docker-ce

# Baixa a versão mais recente do Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Torna o Docker Compose executável
sudo chmod +x /usr/local/bin/docker-compose

# Download
cd /tmp

sudo wget https://raw.githubusercontent.com/Pretoriano88/Infra_WP/refs/heads/main/scripts/docker_scripts/docker-compose.yml


# Arquivo index.html para o volume mapeado do Docker
sudo mkdir html
cd /tmp/html
sudo wget https://raw.githubusercontent.com/Pretoriano88/Infra_WP/refs/heads/main/scripts/docker_scripts/index.html


# Inicializa os contêineres do Docker com Docker Compose
cd /tmp
sudo docker-compose up -d