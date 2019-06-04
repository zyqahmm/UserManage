#!/bin/bash

> ./hosts.txt
egrep ^[0-9] /tmp/inventory |awk '{print $1}' > ./hosts.txt
exec > 01_userchk.sh
echo "
#!/bin/bash
MYNAME=`cat user.config | awk -F = '/MYNAME/{print $2}'`
MYUID=`cat user.config | awk -F = '/MYUID/{print $2}'`
MYGID=`cat user.config | awk -F = '/MYGID/{print $2}'`
DATE=`cat /tmp/inventory | awk -F = '/DATE/{print $2}'`
"

cat 01_stduserchk.sh 
chmod +x 01_userchk.sh
