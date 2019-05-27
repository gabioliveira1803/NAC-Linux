#!/bin/bash
#
#Programa para Realizar Bakup em Debian
#
#Pastas de Origem do apache2
DIR_ORI=("/var/log/apache2" "/var/www")
#Copiar arquivos
DIR_ARQ=("/etc/apache2/apache2.conf" "/etc/apache2/conf-available" "/etc/apache2/conf-enabled")
#Array para trazer os arquivos e logs
CAMINHO=("${DIR_ORI[@]}" "${DIR_ARQ[@]}")
#Pasta de destino para salvar arquivo de backup
DIR_DEST="/backup"
#Data e Hora para ser inserido no backup
DATA=$(date '+%d-%m-%y-%Hh%Mmin')
#Nomeação do backup
BKPName="backup-$DATA.tar.gz"
#Controle da função principal
control=0
#
clear
#
# Principal
principal(){
	if [ $control -eq 0 ]; then
		echo "Para realizar Backup do Banco de Dados Apache2 no Debian"
		echo " "
		echo "Siga os passoa abaixo."
		echo "Digite 1 para verificar a pasta de Backup"
		echo "Digite 2 para verificar o sistema"
		echo "Digite 3 para realizar o Backup"
		echo "Digite 4 para programar o Backup automatico"
		echo "Digite 5 para sair"
		echo "Opção: "
		read opcao
	elif [ $control -eq 1 ]; then
		echo "OPÇÃO INVALIDA!! FAVOR ESCOLHER UMA DAS OPÇÕES ABAIXO: "
		echo " "
		echo "Digite 1 para verificar a pasta de Backup"
		echo "Digite 2 para verificar o sistema"
		echo "Digite 3 para realizar o backup"
		echo "Digite 4 para programar o Backup automatico"
		echo "Digite 5 para Sair"
		echo "Opção: "
		read opcao
	else 
		echo "Backup realizado com sucesso!!"
		echo " "
		echo "Log inserido dentro da pasta /backup/, dentro da pasta home"
	fi
	case $opcao in 
		1)verificarpasta; principal ;;
		2)verificarsistema; principal ;;
		3)fazerbackup; principal ;;
		4)programarbkp; principal;;
		5)echo "Saindo..."; exit ;;
		*)echo "Opção Desconhecida"; principal ;;
	esac
}
verificarsistema(){
	sistema=$(cat /etc/*release | grep ^NAME | cut -d "=" -f2 | cut -d '"' -f2 | cut -d " " -f1)
	if [ $sistema == Debian ]; then
		echo "Seu sistema operacional é compativel com esse script"
	else 
		echo "Seu sistema operacional não é valido, favor utilizar o Debian para rodar esse script."
		exit
	fi
}
fazerbackup(){
	sudo ar -czvf $DIR_DEST/$BKPName ${CAMINHO[@]}
	if [ $? -eq 0 ]; then
		echo "----------------"
		echo "Backup Concluido!"
		touch /backup/log-backup-$DATA.txt
		echo "Backup realizado com sucesso!!" >> /backup/log-backup$DATA.txt
		echo "Criado pelo Usuario: $USER" >> /backup/log-backup-$DATA.txt
		echo "Backup realizado na data: $DATA" >> /backup/log-backup-$DATA.txt
		echo " "
		echo "Log gerado no arquivo log-backup-$DATA.txt"
	else
		echo "ERRO!"
		echo "Não foi possivel realizar o backup."
	fi
}
#Verificação da pasta Backup
verificarpasta(){
	if [ -e "/backup" ]; then
		echo "Diretorio existe!"
		echo 
	else
		echo "Diretorio não existe!"
		echo "Criando diretorio..."
		mkdir /backup
	fi

}

#Automatização do Backup
programarbkp(){
	echo " "
	#Variavel padrao que e necessaria para executar o script.
	BB="/bin/bash"
	echo "Complete com as informações a respeito de quando deseja que o Backup seja executado automaticamente."
	echo "Caso não queira alguma informação referente a data e hora, favor digitar  *. "
	echo " "
	read -p "Digite a hora - 0 a 23: " H
	read -p "Digite o minuto - 0 a 59: " MIN
	read -p "Digite o Dia do Mês - 1 a 31: " DDM
	read -p "Digite o Mês - 1 a 12: " MES
	read -p "Digite o Dia da Semana - 0 a 6 (0 é Domingo): " DDS
	read -p "Digite o Caminho do Script de Backup Automatico: " P
	echo " "
	echo "$MIN $H $DDM $MES $DDS $BB $P" >> /var/spool/cron/crontabs/root
														
}
principal


