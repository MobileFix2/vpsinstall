﻿#!/bin/bash
if [ $(id -u) -eq 0 ]
then
clear
else
echo -e "Execute o script como usuario \033[1;32mroot\033[0m"
exit
fi
if [ -d /etc/vpsconf ]
then
true
else
mkdir /etc/vpsconf
fi
if [ -d /etc/vpsconf/senha ]
then
true
else
mkdir /etc/vpsconf/senha
fi
if [ -d /etc/vpsconf/limite ]
then
true
else
mkdir /etc/vpsconf/limite
fi

function configurarsquid(){
clear
cat -n /etc/issue |grep 1 |cut -d' ' -f6,7,8 |sed 's/1//' |sed 's/	//' > /etc/so 
if [ -f /etc/lsb-release ]
then
sistema=$(cat /etc/lsb-release |grep "DISTRIB_DESCRIPTION" | awk -F = '{print $2}' |sed 's/"//g')
else
sistema=Null
fi
echo -e "\033[1;31mPara a instalação ser correta é preciso o ip.
Digite o ip !\033[0m"
read -p ": " ip
clear
echo -e "\033[1;31m-----> \033[01;37mSeu sistema operacional:\033[1;31m $sistema"
echo -e "\033[1;31m-----> \033[01;37mSeu ip:\033[1;31m $ip"
echo -e "\033[1;31m-----> \033[1;37mSQUID NAS PORTAS:\033[1;31m 80, 8080, 8799, 3128\033[0m"
echo -e "\033[1;31m-----> \033[1;37mSSH NAS PORTAS: \033[1;31m443, 22\033[0m"
echo -e "\033[1;31m-----> \033[1;37mSSH NOS IPS: \033[1;31m$ip, localhost, 127.0.0.1\033[0m"
echo -e "\033[1;31m-----> \033[1;37mFERRAMENTA ADICIONAR DOMINIOS:\033[1;31m addhost\033[0m"

function sshd_config(){ 
echo 'Port 443
PermitRootLogin yes
PubkeyAuthentication yes
PasswordAuthentication yes
' >> /etc/ssh/sshd_config
}

function addihost(){ echo '#!/bin/bash
echo -e "\033[1;31mHosts atualmente permitidos\n\n\033[1;32m$(cat /etc/payloads)\n\033[0m"
echo "Qual host deseja adicionar ?"
read -p ": " host
echo "$host" >> /etc/payloads
squid -k reconfigure > /dev/null 2> /dev/null
squid3 -k reconfigure > /dev/null 2> /dev/null
echo "$host Adicionado" ' > /bin/addhost
chmod a+x /bin/addhost
}
function removerhostf(){ echo '#!/bin/bash
echo -e "\033[1;31mHosts atualmente permitidos\n\n\033[1;32m$(cat /etc/payloads)\n\033[0m"
echo -ne "\033[1;37mQual host deseja remover: \033[0m"
read host
hosts = $(cat /etc/payloads |grep -v $host)
echo "$hosts" > /etc/payloads
squid -k reconfigure >/dev/null 2>/dev/null
squid3 -k reconfigure >/dev/null 2>/dev/null
echo -e "\n\033[1;32mHost Removido\033[0m"
' > /bin/removerhost
}
function payloads(){ echo ".claro.com.br
.claro.com.sv
.vivo.com.br
.ddivulga.com" > /etc/payloads
}

if cat /etc/so |grep -i ubuntu |grep 16 1> /dev/null 2> /dev/null ; then
echo -e "\033[1;37mConfigurando, Aguarde...\033[0m"
apt-get update 1> /dev/null 2> /dev/null
apt-get install -y squid3 1> /dev/null 2> /dev/null

service apache2 stop 1> /dev/null 2> /dev/null
chattr -i /etc/ssh/sshd_config > /dev/null 2> /dev/null
sshd_config
service ssh restart 1> /dev/null 2> /dev/null

echo "http_port 80
http_port 8080
http_port 8799
http_port 3128
visible_hostname VpsPack
acl ip dstdomain $ip
http_access allow ip" > /etc/squid/squid.conf
echo 'acl accept dstdomain -i "/etc/payloads"
http_access allow accept
acl local dstdomain localhost
http_access allow local
acl iplocal dstdomain 127.0.0.1
http_access allow iplocal
http_access deny all' >> /etc/squid/squid.conf

addihost
removerhostf
payloads
service squid restart 1> /dev/null 2> /dev/null
echo -e "\033[1;37mPara adicionar novos hosts ao squid execute o comando \033[1;32maddhost
\033[1;37mPara remover execute o comando \033[1;32mremoverhost\033[1;37m
Os hosts ficam no arquivo /etc/payloads\033[0m"
echo -e "\033[01;31mTudo terminado crie um usuario e teste !! \033[0m"
exit 0
fi

if cat /etc/so |grep -i ubuntu 1> /dev/null 2> /dev/null ; then
echo -e "\033[1;37mConfigurando, Aguarde...\033[0m"
apt-get update 1> /dev/null 2> /dev/null
apt-get install -y squid3 1> /dev/null 2> /dev/null

service apache2 stop 1> /dev/null 2> /dev/null
chattr -i /etc/ssh/sshd_config > /dev/null 2> /dev/null
sshd_config
service ssh restart 1> /dev/null 2> /dev/null

echo "http_port 80
http_port 8080
http_port 8799
http_port 3128
visible_hostname VpsPack
acl ip dstdomain $ip
http_access allow ip" > /etc/squid3/squid.conf
echo 'acl accept dstdomain -i "/etc/payloads"
http_access allow accept
acl local dstdomain localhost
http_access allow local
acl iplocal dstdomain 127.0.0.1
http_access allow iplocal
http_access deny all' >> /etc/squid3/squid.conf
payloads
service squid3 restart 1> /dev/null 2> /dev/null
addihost
removerhostf
echo -e "\033[1;37mPara adicionar novos hosts ao squid execute o comando \033[1;32maddhost
\033[1;37mPara remover execute o comando \033[1;32mremoverhost\033[1;37m
Os hosts ficam no arquivo /etc/payloads\033[0m"
echo -e "\033[01;31mTudo terminado crie um usuario e teste !! \033[0m"
exit 0
fi

if cat /etc/so |grep -i centos 1> /dev/null 2> /dev/null ; then
echo -e "\033[01;37mConfigurando, Aguarde...\033[0m"
yum -y update 1> /dev/null 2> /dev/null
yum install -y squid 1> /dev/null 2> /dev/null

service httpd stop 1> /dev/null 2> /dev/null
chattr -i /etc/ssh/sshd_config > /dev/null 2> /dev/null
sshd_config
service sshd restart 1> /dev/null 2> /dev/null

echo "http_port 80
http_port 8080
http_port 8799
http_port 3128
visible_hostname VpsPack
acl ip dstdomain $ip
http_access allow ip" > /etc/squid/squid.conf
echo 'acl accept dstdomain -i "/etc/payloads"
http_access allow accept
acl local dstdomain localhost
http_access allow local
acl iplocal dstdomain 127.0.0.1
http_access allow iplocal
http_access deny all' >> /etc/squid/squid.conf
payloads
service squid restart 1> /dev/null 2> /dev/null
addihost
removerhostf
echo -e "\033[1;37mPara adicionar novos hosts ao squid execute o comando \033[1;32maddhost
\033[1;37mPara remover execute o comando \033[1;32mremoverhost\033[1;37m
Os hosts ficam no arquivo /etc/payloads\033[0m"
echo -e "\033[01;31mTudo terminado crie um usuario e teste !! \033[0m"
exit
fi

if cat /etc/so |grep -i debian 1> /dev/null 2> /dev/null ; then
echo -e "\033[01;37mConfigurando, Aguarde...\033[0m"
apt-get update 1> /dev/null 2> /dev/null
apt-get install -y squid3 1> /dev/null 2> /dev/null
service apache2 stop 1> /dev/null 2> /dev/null
chattr -i /etc/ssh/sshd_config > /dev/null 2> /dev/null
sshd_config

service ssh restart 1> /dev/null 2> /dev/null

echo "http_port 80
http_port 8080
http_port 8799
http_port 3128
visible_hostname VpsPack
acl ip dstdomain $ip
http_access allow ip" > /etc/squid3/squid.conf
echo 'acl accept dstdomain -i "/etc/payloads"
http_access allow accept
acl local dstdomain localhost
http_access allow local
acl iplocal dstdomain 127.0.0.1
http_access allow iplocal
http_access deny all' >> /etc/squid3/squid.conf
payloads
service squid3 restart 1> /dev/null 2> /dev/null
addihost
removerhostf
echo -e "\033[1;37mPara adicionar novos hosts ao squid execute o comando \033[1;32maddhost
\033[1;37mPara remover execute o comando \033[1;32mremoverhost\033[1;37m
Os hosts ficam no arquivo /etc/payloads\033[0m"
echo -e "\033[01;31mTudo terminado crie um usuario e teste !! \033[0m"
exit 0
fi
if cat /etc/issue |grep -i kernel 1> /dev/null 2> /dev/null ; then
echo -e "\033[01;31mConfigurando, Aguarde...\033[0m"
yum -y update 1> /dev/null 2> /dev/null
yum install -y squid 1> /dev/null 2> /dev/null

service httpd stop 1> /dev/null 2> /dev/null
chattr -i /etc/ssh/sshd_config > /dev/null 2> /dev/null
sshd_config
service sshd restart 1> /dev/null 2> /dev/null

echo "http_port 80
http_port 8080
http_port 8799
http_port 3128
visible_hostname VpsPack
acl ip dstdomain $ip
http_access allow ip" > /etc/squid/squid.conf
echo 'acl accept dstdomain -i "/etc/payloads"
http_access allow accept
acl local dstdomain localhost
http_access allow local
acl iplocal dstdomain 127.0.0.1
http_access allow iplocal
http_access deny all' >> /etc/squid/squid.conf
payloads
service squid restart 1> /dev/null 2> /dev/null
addihost
removerhostf
echo -e "\033[1;37mPara adicionar novos hosts ao squid execute o comando \033[1;32maddhost
\033[1;37mPara remover execute o comando \033[1;32mremoverhost\033[1;37m
Os hosts ficam no arquivo /etc/payloads\033[0m"
echo -e "\033[01;31mTudo terminado crie um usuario e teste !! \033[0m"
exit
fi
echo -e "\033[01;31mConfigurando, Aguarde...\033[0m"
yum -y update 1> /dev/null 2> /dev/null
yum install -y squid 1> /dev/null 2> /dev/null
apt-get update > /dev/null 2> /dev/null
apt-get install -y squid3 > /dev/null 2>/dev/null
service httpd stop 1> /dev/null 2> /dev/null
service apache2 stop >/dev/null 2> /dev/null
chattr -i /etc/ssh/sshd_config > /dev/null 2> /dev/null
sshd_config
service sshd restart 1> /dev/null 2> /dev/null
service ssh restart > /dev/null 2> /dev/null
echo "http_port 80
http_port 8080
http_port 8799
http_port 3128
visible_hostname VpsPack
acl ip dstdomain $ip
http_access allow ip" > /etc/squid*/squid.conf
echo 'acl accept dstdomain -i "/etc/payloads"
http_access allow accept
acl local dstdomain localhost
http_access allow local
acl iplocal dstdomain 127.0.0.1
http_access allow iplocal
http_access deny all' >> /etc/squid*/squid.conf
payloads
service squid restart 1> /dev/null 2> /dev/null
service squid3 restart > /dev/null 2> /dev/null
addihost
removerhostf
echo -e "\033[1;37mPara adicionar novos hosts ao squid execute o comando \033[1;32maddhost
\033[1;37mPara remover execute o comando \033[1;32mremoverhost\033[1;37m
Os hosts ficam no arquivo /etc/payloads\033[0m"
echo -e "\033[01;31mTudo terminado crie um usuario e teste !! \033[0m"
}
function sistemadetalhes(){
if [ -f /proc/cpuinfo ]
then
echo -e "\n\033[1;30mProcessador\033[0m"
modelo=$(cat /proc/cpuinfo |grep "model name" |uniq |awk -F : {'print $2'})
cpucores=$(cat /proc/cpuinfo |grep "cpu cores" |uniq |awk -F : {'print $2'})
cache=$(cat /proc/cpuinfo |grep "cache size" |uniq |awk -F : {'print $2'})
echo -e "\033[1;32mModelo:\033[0m$modelo"
echo -e "\033[1;32mNucleos:\033[0m$cpucores"
echo -e "\033[1;32mMemoria Cache:\033[0m$cache"
echo -e "\033[1;32mArquitetura: \033[0m$(uname -p)"
else
echo -e "\033[1;30mProcessador\033[0m"
echo "Não foi possivel encontrar /proc/cpuinfo"
fi
if [ -f /etc/lsb-release ]
then
echo -e "\n\033[1;30mSistema Operacional\033[0m"
name=$(cat /etc/lsb-release |grep DESCRIPTION |awk -F = {'print $2'})
codename=$(cat /etc/lsb-release |grep CODENAME |awk -F = {'print $2'})
echo -e "\033[1;32mNome: \033[0m$name"
echo -e "\033[1;32mCodeName: \033[0m$codename"
echo -e "\033[1;32mKernel: \033[0m$(uname -s)"
echo -e "\033[1;32mKernel Release: \033[0m$(uname -r)"
if [ -f /etc/os-release ]
then
devlike=$(cat /etc/os-release |grep LIKE |awk -F = {'print $2'})
echo -e "\033[1;32mDerivado do Antecedente OS: \033[0m$devlike"
fi
else
echo -e "\n\033[1;30mSistema Operacional\033[0m"
echo "Não foi possivel encontrar /etc/lsb-release"
fi
if free 1>/dev/null 2>/dev/null
then
echo -e "\n\033[1;30mMemoria RAM\033[0m"
echo -e "\033[1;32mTotal: \033[0m$(free -m |grep -i mem |awk {'print $2'}) MB | $(( $(free -m |grep -i mem |awk {'print $2'}) / 1024 )) GB"
echo -e "\033[1;32mEm Uso: \033[0m$(free -m |grep -i mem |awk {'print $3'}) MB | $(( $(free -m |grep -i mem |awk {'print $3'}) / 1024 )) GB"
echo -e "\033[1;32mLivre: \033[0m$(free -m |grep -i mem |awk {'print $4'}) MB | $(( $(free -m |grep -i mem |awk {'print $4'}) / 1024 )) GB"
echo -e "\n\033[1;30mSwap\033[0m"
echo -e "\033[1;32mTotal: \033[0m$(free -m |grep -i swap |awk {'print $2'}) MB | $(( $(free -m |grep -i swap |awk {'print $2'}) / 1024 )) GB"
echo -e "\033[1;32mEm Uso: \033[0m$(free -m |grep -i swap |awk {'print $3'}) MB | $(( $(free -m |grep -i swap |awk {'print $3'}) / 1024 )) GB"
echo -e "\033[1;32mLivre: \033[0m$(free -m |grep -i swap |awk {'print $4'}) MB | $(( $(free -m |grep -i swap |awk {'print $4'}) / 1024 )) GB"
else
echo -e "\n\033[1;30mMemoria RAM\033[0m"
echo "Não foi possivel obter informações sobre a memoria RAM"
fi
}
function monitorar(){
clear
echo -e "\033[1;37m -------------------------------------------------------\033[0m"
echo -e " \033[47;30m   Usuario                :               Conexoes S   \033[0m"
echo -e "\033[1;37m -------------------------------------------------------\033[0m"
for usur in `awk -F : '$3 > 900 { print $1 }' /etc/passwd |grep -v "nobody" |grep -vi polkitd |grep -vi systemd-[a-z] |grep -vi systemd-[0-9] |sort`; do
if [ -f /etc/vpsconf/limite/$usur ]; then
limite=$(cat -n /etc/vpsconf/limite/$usur |awk '$1 = 1 {print $2}')
else
limite=null
fi
usurnum="$(ps -u $usur |grep sshd |wc -l)\033[1;30m/\033[1;33m$limite"
echo -e "\033[1;33m    $(printf '%-41s%s' $usur $usurnum) \033[0m"
echo -e "\033[1;37m -------------------------------------------------------\033[0m"
done
}
function removerexpirados(){
clear
echo -e "         \033[1;33mRemover Usuarios Expirados\033[0m"
datahoje=$(date +%s)
for user in $(cat /etc/passwd |grep -v "nobody" |awk -F : '$3 > 900 {print $1}')
do
dataexp=$(chage -l $user |grep "Account expires" |awk -F : '{print $2}')
if [[ $dataexp == ' never' ]]; then
id > /dev/null 2>/dev/null
else
dataexpn=$(date -d"$dataexp" '+%d/%m/%Y')
dataexpnum=$(date '+%s' -d"$dataexp")
fi
if [[ $dataexpnum < $datahoje ]]; then
printf "\033[1;31m"
printf '%-41s' $user
printf "\033[0m"
echo "Expired Deleted"
kill $(ps -u $user |awk '{print $1}') >/dev/null 2>/dev/null ; userdel $user
else
printf "\033[1;32m"
printf '%-41s' $user
printf "\033[0m"
echo $dataexpn
fi
done
}
function criarusuarioteste(){
mkdir /etc/usuariosteste 1>/dev/null 2>/dev/null
echo -e "   Usuarios teste"
for testus in $(ls /etc/usuariosteste |sort |sed 's/.sh//g')
do
echo "$testus"
done
printf "\n"
printf "Nome do novo usuario: "; read nome
printf "Senha do usuario: "; read pass
echo -e "\nUse s = segundos, m = minutos, h = horas e d = dias EX: 14s ."
printf "Quanto tempo usuario $nome deve durar: ";read tempoin
tempo=$(echo "$tempoin" |sed 's/ //g')
useradd -M -s /bin/false $nome
(echo $pass;echo $pass) |passwd $nome 1>/dev/null 2>/dev/null
echo "#!/bin/bash
sleep $tempo
kill"' $(ps -u '"$nome |awk '{print"' $1'"}') 1>/dev/null 2>/dev/null
userdel --force $nome
rm -rf /etc/usuariosteste/$nome.sh
exit" > /etc/usuariosteste/$nome.sh
echo -e "Usuario: $nome
Senha: $pass
Validade: $tempo\n
Apos o tempo expirar o usuario sera deletado e todos serão desconectados."
bash /etc/usuariosteste/$nome.sh &
exit
}
function badvpn_install(){
wget https://raw.githubusercontent.com/RicKbrL/VpsConf/master/badvpn.sh && bash badvpn.sh
}
function removerlimite(){
echo -ne "\033[1;32mQual usuario a retirar o limite: \033[0m"
read user
cronsemuser=$(cat /etc/crontab |grep -v "#$user#")
echo "$cronsemuser" > /etc/crontab
rm -rf /etc/vpsconf/limite/$user 2>/dev/null
rm -rf /etc/vpsconf/limite/$user.sh 2>/dev/null
pids=$(ps x |grep "#$user#" |awk {'print $1'})
kill $pids 2>/dev/null
kill "$pids" 2>/dev/null
kill -9 `ps x |grep "#$user#" |awk {'print $1'}` 2>/dev/null
kill `ps x |grep "#$user#" |awk {'print $1'}` 2>/dev/null
echo -e "\033[1;37mUsuario: $user, Limite removido\033[0m"
}
function backup_de_usuarios(){
clear
echo -e "\033[1;37mFazendo Backup de Usuarios...\033[0m"
for user in `awk -F : '$3 > 900 { print $1 }' /etc/passwd |grep -v "nobody" |grep -vi polkitd |grep -vi systemd-[a-z] |grep -vi systemd-[0-9]`
do
if [ -e /etc/vpsconf/senha/$user ]
then
pass=$(cat /etc/vpsconf/senha/$user)
else
echo -e "\033[1;31mNão foi possivel ter a senha do usuario\033[1;37m ($user)"
read -p "Digite a Senha Manualmente ou Tecle ENTER: " pass
fi

if [ -e /etc/vpsconf/limite/$user ]
then
limite=$(cat /etc/vpsconf/limite/$user)
echo "$user:$pass:$limite" >> /etc/vpsconf/backup
echo -e "\033[1;37mUser $user Backup [\033[1;31mOK\033[1;37m]\033[0m"
else
echo "$user:$pass" >> /etc/vpsconf/backup
echo -e "\033[1;37mUser $user Backup [\033[1;31mOK\033[1;37m]\033[0m"
fi
done
echo " "
echo -e "\033[1;31mBackup Completo !!!\033[0m"
echo " "
echo -e "\033[1;37mAs informações sobre usuarios ficam no arquivo \033[1;31m /etc/vpsconf/backup \033[1;37m
Guarde os Para uma futura Restauração\033[0m"
}
function mudarnome(){
printf "Usuario qual deseja mudar o nome: "; read user
if cat /etc/passwd |grep $user: >/dev/null 2>/dev/null
then
printf ""
else
echo "Usuario não existe"
exit
fi
printf "Novo nome para usuario $user: "; read nome
usermod -l $nome $user 1>/dev/null 2>/dev/null
echo -e "\nUsuario: $user, Novo nome: $nome."
exit
}
function firewallblock(){
read -p "Digite o ip do vps: " ip
echo Configurando...
sleep 1
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -t filter -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -d $ip --dport 443 -m state --state NEW -j ACCEPT
iptables -A OUTPUT -p tcp -d $ip --dport 80 -m state --state NEW -j ACCEPT
iptables -A OUTPUT -p tcp --dport 53 -m state --state NEW -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -m state --state NEW -j ACCEPT
iptables -A OUTPUT -p tcp --dport 67 -m state --state NEW -j ACCEPT
iptables -A OUTPUT -p udp --dport 67 -m state --state NEW -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 3128 -j ACCEPT
iptables -A INPUT -p tcp --dport 8799 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 8080 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 3128 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 8799 -j ACCEPT
iptables -A FORWARD -p tcp --dport 8080 -j ACCEPT
iptables -A FORWARD -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -p tcp --dport 3128 -j ACCEPT
iptables -A FORWARD -p tcp --dport 8799 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
iptables -A INPUT -p tcp --dport 10000 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 10000 -j ACCEPT
echo -e "\033[1;37mFirewall modificado
Portas 443 22 8799 8080 80 3128
Bloqueio ICMP
Bloqueio Torrent\033[0m"
}
function resetfirewall(){
iptables -F
iptables -X
iptables -t mangle -F
iptables -t mangle -X
iptables -t nat -F
iptables -t nat -X
iptables -t filter -F
iptables -t filter -X
echo "Regras resetadas"
}
function detalhes_usuarios(){
clear

echo -e "\033[1;30m----------------------------------------------------------------------\033[0m"
echo -e "\033[1;37m Usuario               Senha               Data E.          Logins S. \033[0m"
echo -e "\033[1;30m----------------------------------------------------------------------\033[0m"
for users in `awk -F : '$3 > 900 { print $1 }' /etc/passwd |sort |grep -v "nobody" |grep -vi polkitd |grep -vi system-`
do

if cat /etc/vpsconf/limite/$users > /dev/null 2> /dev/null
then
limitecs=$(cat /etc/vpsconf/limite/$users)
else
limitecs="null"
fi

if  senha=$(cat /etc/vpsconf/senha/$users > /dev/null 2> /dev/null)
then
senha=$(cat /etc/vpsconf/senha/$users)
else
senha="null"
fi

data=$(chage -l $users |grep -i co |awk -F : '{print $2}')
if [ $data = never ] 2> /dev/null
then
date="Nunca"
fi
detalhesdata=$(printf '%-18s' "$data")
detalheslimit=$(printf '%-10s' "$limitecs")
detalhes=$(printf ' %-21s' "$users")
detalhespass=$(printf '%-18s' "$senha")
echo -e "\033[1;33m$detalhes $detalhespass $detalhesdata $detalheslimit\033[0m"
echo -e "\033[1;30m----------------------------------------------------------------------\033[0m"
done
}
function restaurar_usuarios(){
echo -n "Digite o diretorio do arquivo Backup: "
read arq
echo -e "\033[1;37mRestaurando Usuarios...\033[0m"

for user in `cat $arq`
do
usuario=$(echo "$user" |awk -F : '{print $1}')
senha=$(echo "$user" |awk -F : '{print $2}')
if cat /etc/passwd |grep $usuario: 1> /dev/null 2>/dev/null
then
echo " " > /dev/null
else
echo "$user" |cut -d: -f3 1> /dev/null 2>/dev/null
  if [ $? = 0 ]
  then
  limite=$(echo "$user" |awk -F : '{print $3}')
  useradd -M -s /bin/false $usuario
  (echo $senha ; echo $senha) | passwd $usuario > /dev/null 2> /dev/null
  limit $usuario $limite 1> /dev/null 2> /dev/null
  echo "$senha" > /etc/gerenciadorinfo/senha/$usuario
  else
  useradd -M -s /bin/false $usuario
  (echo $senha ; echo $senha) | passwd $usuario > /dev/null 2> /dev/null
  echo "$senha" > /etc/gerenciadorinfo/senha/$usuario
  fi
  echo -e "\033[1;37mUsuario: \033[1;31m$usuario \033[1;37mBackup: [\033[1;31mOk\033[1;37m]\033[0m"
fi
done
}
function banner(){
sshd_config_bak=$(cat /etc/ssh/sshd_config |grep -v "Banner")
echo "$sshd_config_bak" > /etc/ssh/sshd_config
echo "Banner /etc/bannerssh" >> /etc/ssh/sshd_config
service ssh restart 1>/dev/null 2>/dev/null
service sshd restart 1>/dev/null 2>/dev/null
if [ -f /etc/bannerssh ]
then
banner=$(cat /etc/bannerssh)
else
banner="Não há um banner no momento"
fi
echo -e "\033[1;32mBanner atual\n\n\033[1;37m$banner\n\033[0m"
echo "Qual banner deseja adicionar (ctrl + c para sair )"
read -p ": " bannerssh
echo "$bannerssh" > /etc/bannerssh
service ssh restart 1> /dev/null 2>/dev/null
service sshd restart 1>/dev/null 2>/dev/null
}
function deletar_todos(){
for user in $(cat /etc/passwd |awk -F : '$3 > 900 {print $1}' |grep -v "rick" |grep -vi "nobody")
do
userpid=$(ps -u $user |awk {'print $1'})
kill "$userpid" 2>/dev/null
userdel $user
echo "$user Deletado"
done
}
clear
if [[ $1 == "" ]]
then
echo -e "\033[1;37m       vpsconf \033[0m"
echo -e "\033[1;37mEscolha uma opção:    Para Sair Ctrl + C\033[1;33m
[\033[1;30m01\033[1;33m] Configurar_Squid_SSH \033[1;30m(Squid e openssh configuração)\033[1;33m
[\033[1;30m02\033[1;33m] Limite \033[1;30m(limite de conexoes simultaneas)\033[1;33m
[\033[1;30m03\033[1;33m] Criar_Usuario \033[1;30m(Criar usuarios)\033[1;33m
[\033[1;30m04\033[1;33m] Remover_expirados \033[1;30m(Remover usuarios ja expirados)\033[1;33m
[\033[1;30m05\033[1;33m] Criar_Teste \033[1;30m(Criar usuarios de curta duração)\033[1;33m
[\033[1;30m06\033[1;33m] BadVpn \033[1;30m(Instala badvpn para tunnel udp)\033[1;33m
[\033[1;30m07\033[1;33m] BadVpn_Start \033[1;30m(liberar chamadas voip, jogos online, etc)\033[1;33m
[\033[1;30m08\033[1;33m] BadVpn_Stop \033[1;30m(Parar serviço do badvpn)\033[1;33m
[\033[1;30m09\033[1;33m] Remover_Limite \033[1;30m(Remover limite de conexoes de um usuario)\033[1;33m
[\033[1;30m10\033[1;33m] Mudar_Nome \033[1;30m(Mudar nome de um usuario)\033[1;33m
[\033[1;30m11\033[1;33m] Redefinir_Usuario \033[1;30m(Redefinir Data, senha, etc)\033[1;33m
[\033[1;30m12\033[1;33m] Deletar_Usuario \033[1;30m(Menu Deletar, Desconectar, etc)\033[1;33m
[\033[1;30m13\033[1;33m] Firewall-block \033[1;30m(bloquear torrent, icmp [\033[1;31mRISCOS\033[1;30m])\033[1;33m
[\033[1;30m14\033[1;33m] Reset_Firewall \033[1;30m(Resetar regras iptables [\033[1;31mRISCOS\033[1;30m])\033[1;33m
[\033[1;30m15\033[1;33m] Addhost \033[1;30m(Adicionar Hosts aceitos pelo squid )\033[1;33m
[\033[1;30m16\033[1;33m] Remover_Host \033[1;30m(Remover Hosts aceitos pelo squid)\033[1;33m
[\033[1;30m17\033[1;33m] Monitorar \033[1;30m(Monitorar conexões atuais)\033[0m\033[1;33m
[\033[1;30m18\033[1;33m] Backup-Users \033[1;30m(Backup dos usuarios)\033[1;33m
[\033[1;30m19\033[1;33m] Rest-Users \033[1;30m(Restaurar usuarios feito backup)\033[1;33m
[\033[1;30m20\033[1;33m] Usuarios_Detalhes \033[1;30m(Informacoes sobre os usuarios !!)\033[1;33m
[\033[1;30m21\033[1;33m] Banner \033[1;30m(Adicionar um banner)\033[1;33m
[\033[1;30m22\033[1;33m] Speedtest \033[1;30m(Teste de conexão [velocidade de banda])\033[1;33m
[\033[1;30m23\033[1;33m] Sistema_Detalhes \033[1;30m(Detalhes sobre o Sistema)\033[1;33m
[\033[1;30m24\033[1;33m] Deletar_Todos \033[1;30m(Todos os usuarios serão deletados)\033[1;33m
[\033[1;30m25\033[1;33m] Desinstalar \033[1;30m(Remover vpsconf)\033[0m"
read -p ": " opcao
else
opcao=$1
fi
case $opcao in
  1 | 01 )
   configurarsquid;;
  2 | 02 )
   read -p "Usuario: " user
   read -p "Limite: " limite
   limite $user $limite;;
  3 | 03 )
   criarusuario;;
  4 | 04 )
   removerexpirados;;
  5 | 05 )
   criarusuarioteste;;
  6 | 06 )
   badvpn_install;;
  7 | 07 )
   badvpn start;;
  8 | 08 )
   badvpn stop;;
  9 | 09 )
   removerlimite;;
  10)
   mudarnome;; 
  11)
   redefinirusuario;;
  12)
   deletarusuario;;
  13)
   firewallblock;;
  14)
   resetfirewall;;
  15)
   addhost;;
  16)
   removerhost;;
  17)
   monitorar;;
  18)
   backup_de_usuarios;;
  19)
   restaurar_usuarios;;
  20)
   detalhes_usuarios;;
  21)
   banner;;
  22)
   speedtest.py;;
  23)
   sistemadetalhes;;
  24)
   deletar_todos;;
  25)
   rm -rf /bin/speedtest.py 2>/dev/null
   rm -rf /bin/deletarusuario 2>/dev/null
   rm -rf /bin/redefinirusuario 2>/dev/null
   rm -rf /bin/limite 2>/dev/null
   rm -rf /bin/criarusuario 2>/dev/null
   rm -rf /bin/vpsconf 2>/dev/null;;
esac