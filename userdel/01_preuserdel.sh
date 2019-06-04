#!/bin/bash

> ./hosts.txt
egrep ^[0-9] /tmp/inventory |awk '{print $1}' > ./hosts.txt
exec > 01_userdel.sh
echo "
#!/bin/bash
MYNAME=`cat user.config | awk -F = '/MYNAME/{print $2}'`
MYUID=`cat user.config | awk -F = '/MYUID/{print $2}'`
MYHOME=`cat user.config | awk -F = '/MYHOME/{print $2}'`
DATE=`cat /tmp/inventory | awk -F = '/DATE/{print $2}'`
"

cat 01_stduserdel.sh 
chmod +x 01_userdel.sh
