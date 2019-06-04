
#!/bin/bash
MYNAME=test01
MYUID=
MYGID=
DATE=2018-06-28-09-12-09


> /tmp/local_ip.txt
/sbin/ip a | grep "inet "|awk '{print $2}'|awk -F / '{print $1}' > /tmp/local_ip.txt
for i in `cat /tmp/hosts.txt`;do
        for j in `cat /tmp/local_ip.txt`;do
                [ "$i" = "$j" ] && IP=$i && break 2
        done
done

LANG=

# Check if UID is a number.
if [ "$MYUID" ];then
  re='^[0-9]+$'
  if ! [[ $MYUID =~ $re ]] ; then
    OUTPUT="error"
    RESULT="UID should be a number."
    echo -e "$IP\t$OUTPUT\t$RESULT" > /tmp/$DATE
    exit
  fi
fi

# if vars was given a value
if [ ! "$MYNAME" -a ! "$MYUID" -a ! "$MYGID" ];then
    OUTPUT="error"
    RESULT="none args,choose MYNAME or MYUID or MYGID"
    echo -e "$IP\t$OUTPUT\t$RESULT" > /tmp/$DATE
    exit
fi

# if vars was given to much values
if [ "$MYNAME" -a "$MYUID"  ] ;then
    OUTPUT="error"
    RESULT="too much args,choose one of the MYNAME or MYUID or MYGID"
    echo -e "$IP\t$OUTPUT\t$RESULT" > /tmp/$DATE
    exit
fi

# if vars was given to much values
if [ "$MYNAME" -a "$MYGID" ] ;then
    OUTPUT="error"
    RESULT="too much args,choose one of the MYNAME or MYUID or MYGID"
    echo -e "$IP\t$OUTPUT\t$RESULT" > /tmp/$DATE
    exit
fi

# if vars was given to much values
if [ "$MYGID" -a "$MYUID" ] ;then
    OUTPUT="error"
    RESULT="too much args,choose one of the MYNAME or MYUID or MYGID"
    echo -e "$IP\t$OUTPUT\t$RESULT" > /tmp/$DATE
    exit
fi

# if vars was given to much values
if [ "$MYNAME" -a "$MYUID" -a "$MYGID" ];then
    OUTPUT="error"
    RESULT="too much args,choose one of the MYNAME or MYUID or MYGID"
    echo -e "$IP\t$OUTPUT\t$RESULT" > /tmp/$DATE
    exit
fi

# if vars  MYNAME was given a value,check user $MYNAME
if [ "$MYNAME" ];then
  id $MYNAME
  VARS=$?
  if [ $VARS -eq 1 ];then
    OUTPUT="error"
    RESULT="no such user $MYNAME"
    echo -e "$IP\t$OUTPUT\t$RESULT" > /tmp/$DATE
    exit
  else
    RESULT="success"
    ID=`id $MYNAME`
    MYSHELL=`getent passwd $MYNAME|awk -F : '{print $7}'`
    MYHOME=`getent passwd $MYNAME|awk -F : '{print $6}'`
  fi
fi

# if vars  UID was given a value,check user $MYNAME
if [ "$MYUID" ];then
  MYNAME=`getent passwd $MYUID |awk -F : '{print $1}'`
  if [ ! "$MYNAME" ];then
    OUTPUT="error"
    RESULT="no such user UID is $MYUID"
    echo -e "$IP\t$OUTPUT\t$RESULT" > /tmp/$DATE
    exit
  else
    RESULT="success"
    ID=`id $MYNAME`
    MYSHELL=`cat /etc/passwd|grep ^$MYNAME|awk -F : '{print $7}'`
    MYHOME=`cat /etc/passwd|grep ^$MYNAME|awk -F : '{print $6}'`
  fi
fi

# if vars  MYGID was given a value,check user $MYNAME
if [ "$MYGID" ];then
  MYNAME=`getent group $MYGID |awk -F : '{print $1}'`
  if [ ! "$MYNAME" ];then
    OUTPUT="error"
    RESULT="no such user GID is $MYGID"
    echo -e "$IP\t$OUTPUT\t$RESULT" > /tmp/$DATE
    exit
  else
    RESULT="success"
    ID=`id $MYNAME`
    MYSHELL=`cat /etc/passwd|grep ^$MYNAME|awk -F : '{print $7}'`
    MYHOME=`cat /etc/passwd|grep ^$MYNAME|awk -F : '{print $6}'`
  fi
fi

exec > /tmp/$DATE
echo "$IP\t$RESULT\t\t\t\t$ID\t\t$MYHOME\t$MYSHELL"

