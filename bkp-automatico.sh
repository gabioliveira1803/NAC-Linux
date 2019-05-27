#!/bin/bash

#Variavel contem Hora e Data
DATA=$(date "+%d-%m-%y_%Hh%Mm")

#Variavel contem informacao do Sistema
sistema=$(cat /etc/*release | grep ^NAME | cut -d "=" -f2 | cut -d '"' -f2 | cut -d " " -f1)

#Condicao para verificar informacao do sistema na Variavel SO
if [ $sistema == Debian ]; then
	echo "Sistema: $SO"
else
	echo "Sistema: $SO"
	exit
fi

#Sera feito um Backup do Diretorio e dos Arquivos abaixo para a pasta "/Backup_WebServer"
#	Diretorio: /var/log/apache2/
#	Arquivo:   /etc/apache2/apache2.conf
#	Arquivo:   /etc/apache2/conf-available
#	Arquivo:   /etc/apache2/conf-enabled

#Criacao e Verificacao se Diretorio de Backup Existe
if [ -e "/backup" ]; then
	echo "Diretorio existe!"
else
	echo "Diretorio não existe."
	echo "Criando diretorio..."
	mkdir /backup
fi

#Variaveis Contem Diretorio e Arquivos
DIR_DEST="/backup"
DIR_ORI=("/var/log/apache2" "/var/www")
DIR_ARQ=("/etc/apache2/apache2.conf" "/etc/apache2/conf-available" "/etc/apache2/conf-enabled")
CAMINHO=("${DIR_ORI[@]}" "${DIR_ARQ[@]}")
BKPName="backup-$DATA.tar.gz"

#Compactando os arquivos e enviando para o Local de Backup
sudo tar -czvf $DIR_DEST/$BKPName ${CAMINHO[@]}


