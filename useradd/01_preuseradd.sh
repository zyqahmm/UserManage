#!/bin/bash

> ./hosts.txt
egrep ^[0-9] /tmp/inventory |awk '{print $1}' > ./hosts.txt
exec > 01_useradd.sh
echo "
#!/bin/bash
MYNAME=`cat user.config | awk -F = '/MYNAME/{print $2}'`
MYUID=`cat user.config | awk -F = '/MYUID/{print $2}'`
BASICGID=`cat user.config | awk -F = '/BASICGID/{print $2}'`
MYGID=`cat user.config | awk -F = '/MYGID/{print $2}'`
MYHOME=`cat user.config | awk -F = '/MYHOME/{print $2}'`
MYSHELL=`cat user.config | awk -F = '/MYSHELL/{print $2}'`
MYPASSWD=`cat user.config | awk -F = '/MYPASSWD/{print $2}'`
DATE=`cat /tmp/inventory | awk -F = '/DATE/{print $2}'`
"

cat 01_stduseradd.sh 
chmod +x 01_useradd.sh
