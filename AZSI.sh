#!/bin/bash

#author Panca Putra Pahlawan

echo "--------------------------------------------------------------"
echo "|  Auto Script Zabbix Integration - Ubuntu & Centos V.0.1.0  |"
echo "|                https://github.com/EPX-PANCA                |"
echo "--------------------------------------------------------------"

while getopts u:p: flag; do
    case "${flag}" in
        u) USER_SERVER=${OPTARG};;
        p) SECRET=${OPTARG};;
        
    esac
done

if [ -z "$USER_SERVER" ] || [ -z "$SECRET" ]
then
   echo "Try Again, Please Check Parameters and Arguments";
   exit 1;
fi

echo "Add Dependencies"
sudo apt install sshpass -y


if [ -f /etc/lsb-release -o -d /etc/lsb-release.d ]; then
    echo "[ Ubuntu Server ]"
    echo "Installation & Configuration...."
    sshpass -p $SECRET ssh -o StrictHostKeyChecking=no $USER_SERVER "echo "$SECRET" | sudo -S apt update"
    sshpass -p $SECRET ssh -o StrictHostKeyChecking=no $USER_SERVER "echo "$SECRET" | sudo -S apt install snmpd snmp -y"
    sshpass -p $SECRET ssh -o StrictHostKeyChecking=no $USER_SERVER "echo "$SECRET" | sudo -S sudo rm /etc/snmp/snmpd.conf"
    sshpass -p $SECRET ssh -o StrictHostKeyChecking=no $USER_SERVER "echo "$SECRET" | sudo -S wget https://raw.githubusercontent.com/EPX-PANCA/zabbix-config/main/snmpd.conf -P /etc/snmp/"
    sshpass -p $SECRET ssh -o StrictHostKeyChecking=no $USER_SERVER "echo "$SECRET" | sudo -S systemctl restart snmpd"
    sshpass -p $SECRET ssh -o StrictHostKeyChecking=no $USER_SERVER "echo "$SECRET" | sudo -S systemctl enable snmpd"
    sshpass -p $SECRET ssh -o StrictHostKeyChecking=no $USER_SERVER "echo "$SECRET" | sudo -S systemctl status snmpd"
    sshpass -p $SECRET ssh -o StrictHostKeyChecking=no $USER_SERVER "echo "$SECRET" | sudo -S snmpwalk -v2c -c puskomut 127.0.0.1"
    sshpass -p $SECRET ssh -o StrictHostKeyChecking=no $USER_SERVER "echo "$SECRET" | sudo -S ip address | grep inet"
    echo "Installation Complete"
else
    echo "[ Centos Server ]"
    sshpass -p $SECRET ssh -o StrictHostKeyChecking=no $USER_SERVER "echo "$SECRET" | sudo -S yum -y install net-snmp net-snmp-utils"
    sshpass -p $SECRET ssh -o StrictHostKeyChecking=no $USER_SERVER "echo "$SECRET" | sudo -S sudo rm /etc/snmp/snmpd.conf"
    sshpass -p $SECRET ssh -o StrictHostKeyChecking=no $USER_SERVER "echo "$SECRET" | sudo -S wget https://raw.githubusercontent.com/EPX-PANCA/zabbix-config/main/centos/snmpd.conf -P /etc/snmp/"
    sshpass -p $SECRET ssh -o StrictHostKeyChecking=no $USER_SERVER "echo "$SECRET" | sudo -S systemctl restart snmpd"
    sshpass -p $SECRET ssh -o StrictHostKeyChecking=no $USER_SERVER "echo "$SECRET" | sudo -S systemctl enable snmpd"
    sshpass -p $SECRET ssh -o StrictHostKeyChecking=no $USER_SERVER "echo "$SECRET" | sudo -S systemctl status snmpd"
    sshpass -p $SECRET ssh -o StrictHostKeyChecking=no $USER_SERVER "echo "$SECRET" | sudo -S snmpwalk -v2c -c puskomut 127.0.0.1"
    sshpass -p $SECRET ssh -o StrictHostKeyChecking=no $USER_SERVER "echo "$SECRET" | sudo -S ip address | grep inet"
fi
