#!/bin/bash

> ./hosts.txt
egrep ^[0-9] /tmp/inventory |awk '{print $1}' > ./hosts.txt
exec > 01_usermod.sh
echo "
#!/bin/bash
MYNAME=`cat user.config | awk -F = '/MYNAME/{print $2}'`
NEWNAME=`cat user.config | awk -F = '/NEWNAME/{print $2}'`
NEWUID=`cat user.config | awk -F = '/NEWUID/{print $2}'`
NEWGID=`cat user.config | awk -F = '/NEWGID/{print $2}'`
NEWGROUPS=`cat user.config | awk -F = '/NEWGROUPS/{print $2}'`
NEWHOME=`cat user.config | awk -F = '/NEWHOME/{print $2}'`
NEWSHELL=`cat user.config | awk -F = '/NEWSHELL/{print $2}'`
NEWPASSWD=`cat user.config | awk -F = '/NEWPASSWD/{print $2}'`
LOCK=`cat user.config | awk -F = '/^LOCK/{print $2}'`
UNLOCK=`cat user.config | awk -F = '/^UNLOCK/{print $2}'`
DATE=`cat /tmp/inventory | awk -F = '/DATE/{print $2}'`
"

cat 01_stdusermod.sh 
chmod +x 01_usermod.sh
