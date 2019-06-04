
#!/bin/bash
MYNAME=test2
NEWNAME=test3
NEWUID=
NEWGID=
NEWGROUPS=
NEWHOME=
NEWSHELL=
NEWPASSWD=redhat
LOCK=
UNLOCK=yes
DATE=2018-06-29-13-42-06

LANG=

> /tmp/local_ip.txt
/sbin/ip a | grep "inet "|awk '{print $2}'|awk -F / '{print $1}' > /tmp/local_ip.txt
for i in `cat /tmp/hosts.txt`;do
        for j in `cat /tmp/local_ip.txt`;do
                [ "$i" = "$j" ] && IP=$i && break 2
        done
done

# Check if MYNAME was given
if [ ! "$MYNAME" ];then
   RESULT=error
   OUTPUT="you should give MYNAME a value"
   echo -e "$IP\t$RESULT\t\t$OUTPUT" > /tmp/$DATE
   exit
fi

# Check if UID is a number.
if [ "$NEWUID" ];then
  re='^[0-9]+$'
  if ! [[ $NEWUID =~ $re ]] ; then
    RESULT=error
    OUTPUT="UID should be a number."
    echo -e "$IP\t$RESULT\t\t$OUTPUT" > /tmp/$DATE
    exit
  fi
fi

# Check if home directory is in good format.
if [ "$NEWHOME" ];then
  re='^/.*$'
  if ! [[ $NEWHOME =~ $re ]] ; then
    RESULT=error
    OUTPUT="The home directory should start with /."
    echo -e "$IP\t$RESULT\t\t$OUTPUT" > /tmp/$DATE
    exit 
  fi
fi

# Check if login shell file exists.
if [ "$NEWSHELL" ];then
  if [ ! -x $NEWSHELL ]; then
    RESULT=error
    OUTPUT="The login shell does not exist."
    echo -e "$IP\t$RESULT\t\t$OUTPUT" > /tmp/$DATE
    exit
  fi
fi

#CMD="/usr/sbin/usermod $MYNAME"
CMD="/usr/sbin/usermod"
#ERRORS="> /tmp/errors 2>&1"
if [ "$NEWUID" -a "$NEWGID" -a "$NEWGROUPS" -a "$NEWSHELL" -a "$NEWHOME" ];then $CMD -u $NEWUID -g $NEWGID -G $NEWGROUPS -s $NEWSHELL -d $NEWHOME $MYNAME > /tmp/errors 2>&1 ;
elif [ "$NEWGID" -a "$NEWGROUPS" -a "$NEWSHELL" -a "$NEWHOME" ];then $CMD -g $NEWGID -G $NEWGROUPS -s $NEWSHELL -d $NEWHOME $MYNAME > /tmp/errors 2>&1 ;
elif [ "$NEWUID" -a "$NEWGROUPS" -a "$NEWSHELL" -a "$NEWHOME" ];then $CMD -u $NEWUID -G $NEWGROUPS -s $NEWSHELL -d $NEWHOME $MYNAME > /tmp/errors 2>&1 ;
elif [ "$NEWUID" -a "$NEWGID" -a "$NEWSHELL" -a "$NEWHOME" ];then $CMD -u $NEWUID -g $NEWGID -s $NEWSHELL -d $NEWHOME $MYNAME > /tmp/errors 2>&1 ;
elif [ "$NEWUID" -a "$NEWGID" -a "$NEWGROUPS" -a "$NEWHOME" ];then $CMD -u $NEWUID -g $NEWGID -G $NEWGROUPS -d $NEWHOME $MYNAME > /tmp/errors 2>&1 ;
elif [ "$NEWUID" -a "$NEWGID" -a "$NEWGROUPS" -a "$NEWSHELL" ];then $CMD -u $NEWUID -g $NEWGID -G $NEWGROUPS -s $NEWSHELL $MYNAME > /tmp/errors 2>&1 ;
elif [ "$NEWGROUPS" -a "$NEWSHELL" -a "$NEWHOME" ];then $CMD -G $NEWGROUPS -s $NEWSHELL -d $NEWHOME $MYNAME > /tmp/errors 2>&1 ;
elif [ "$NEWGID" -a "$NEWSHELL" -a "$NEWHOME" ];then $CMD -g $NEWGID -s $NEWSHELL -d $NEWHOME $MYNAME > /tmp/errors 2>&1 ;
elif [ "$NEWGID" -a "$NEWGROUPS" -a "$NEWHOME" ];then $CMD -g $NEWGID -G $NEWGROUPS -d $NEWHOME $MYNAME > /tmp/errors 2>&1 ;
elif [ "$NEWGID" -a "$NEWGROUPS" -a "$NEWSHELL" ];then $CMD -g $NEWGID -G $NEWGROUPS -s $NEWSHELL $MYNAME > /tmp/errors 2>&1 ;
elif [ "$NEWUID" -a "$NEWSHELL" -a "$NEWHOME" ];then $CMD -u $NEWUID -s $NEWSHELL -d $NEWHOME $MYNAME > /tmp/errors 2>&1 ;
elif [ "$NEWUID" -a "$NEWGROUPS" -a "$NEWHOME" ];then $CMD -u $NEWUID -G $NEWGROUPS -d $NEWHOME $MYNAME > /tmp/errors 2>&1 ;
elif [ "$NEWUID" -a "$NEWGROUPS" -a "$NEWSHELL" ];then $CMD -u $NEWUID -G $NEWGROUPS -s $NEWSHELL $MYNAME > /tmp/errors 2>&1 ;
elif [ "$NEWUID" -a "$NEWGID" -a "$NEWHOME" ];then $CMD -u $NEWUID -g $NEWGID -d $NEWHOME $MYNAME > /tmp/errors 2>&1 ;
elif [ "$NEWUID" -a "$NEWGID" -a "$NEWSHELL" ];then $CMD -u $NEWUID -g $NEWGID -s $NEWSHELL $MYNAME > /tmp/errors 2>&1 ;
elif [ "$NEWUID" -a "$NEWGID" -a "$NEWGROUPS" ];then $CMD -u $NEWUID -g $NEWGID -G $NEWGROUPS $MYNAME > /tmp/errors 2>&1 ;
elif [ "$NEWSHELL" -a "$NEWHOME" ];then $CMD -s $NEWSHELL -d $NEWHOME $MYNAME > /tmp/errors 2>&1 ;
elif [ "$NEWGROUPS" -a "$NEWHOME" ];then $CMD -G $NEWGROUPS -d $NEWHOME $MYNAME > /tmp/errors 2>&1 ;
elif [ "$NEWGROUPS" -a "$NEWSHELL" ];then $CMD -G $NEWGROUPS -s $NEWSHELL $MYNAME > /tmp/errors 2>&1 ;
elif [ "$NEWGID" -a "$NEWHOME" ];then $CMD -g $NEWGID -d $NEWHOME $MYNAME > /tmp/errors 2>&1 ;
elif [ "$NEWGID" -a "$NEWSHELL" ];then $CMD -g $NEWGID -s $NEWSHELL $MYNAME > /tmp/errors 2>&1 ;
elif [ "$NEWGID" -a "$NEWGROUPS" ];then $CMD -g $NEWGID -G $NEWGROUPS $MYNAME > /tmp/errors 2>&1 ;
elif [ "$NEWUID" -a "$NEWHOME" ];then $CMD -u $NEWUID -d $NEWHOME $MYNAME > /tmp/errors 2>&1 ;
elif [ "$NEWUID" -a "$NEWSHELL" ];then $CMD -u $NEWUID -s $NEWSHELL $MYNAME > /tmp/errors 2>&1 ;
elif [ "$NEWUID" -a "$NEWGROUPS" ];then $CMD -u $NEWUID -G $NEWGROUPS $MYNAME > /tmp/errors 2>&1 ;
elif [ "$NEWUID" -a "$NEWGID" ];then $CMD -u $NEWUID -g $NEWGID $MYNAME > /tmp/errors 2>&1 ;
elif [ "$NEWHOME" ];then $CMD -d $NEWHOME $MYNAME > /tmp/errors 2>&1 ;
elif [ "$NEWSHELL" ];then $CMD -s $NEWSHELL $MYNAME > /tmp/errors 2>&1 ;
elif [ "$NEWGROUPS" ];then $CMD -G $NEWGROUPS $MYNAME > /tmp/errors 2>&1 ;
elif [ "$NEWGID" ];then $CMD -g $NEWGID $MYNAME > /tmp/errors 2>&1 ;
elif [ "$NEWUID" ];then $CMD -u $NEWUID $MYNAME > /tmp/errors 2>&1 ;
fi

VARS=$?

case $VARS in
0)
 RESULT=success
 OUTPUT="changed user $MYNAME attributes"
 if [ "$NEWPASSWD" ];then
 echo "$NEWPASSWD" | passwd --stdin $MYNAME > /tmp/passwd 2>&1
   if [ $? -ne 0  ];then
     OUTPUT=`cat /tmp/passwd`
     RESULT="add passwd fail"
   fi
 fi
 if [ "$NEWNAME" ];then /usr/sbin/usermod -l $NEWNAME $MYNAME > /tmp/newname 2>&1;
   if [ $? -ne 0  ];then
     OUTPUT=`cat /tmp/newname`
     RESULT="change user's name fail"
   fi
 fi
;;
*)
 RESULT=error
 OUTPUT=`cat /tmp/errors`
;;
esac

if [ $LOCK = yes -o $LOCK = YES ];then /usr/sbin/usermod -L $MYNAME ;
fi

if [ $UNLOCK = yes -o $UNLOCK = YES ];then /usr/sbin/usermod -U $MYNAME ;
fi

exec > /tmp/$DATE
echo "$IP\t$RESULT\t\t$OUTPUT"

