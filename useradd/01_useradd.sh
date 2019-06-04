
#!/bin/bash
MYNAME=test23
MYUID=
BASICGID=
MYGID=
MYHOME=
MYSHELL=
MYPASSWD=
DATE=2018-09-17-15-30-05

LANG=
# 0   成功
# 1   无法更新密码文件
# 2   无效的命令语法
# 3   给了选项一个无效的参数
# 4   UID 已经使用 (且没有 -o)
# 6   指定的组不存在
# 9   用户名已被使用
# 10  无法更新组文件
# 12  无法创建主目录
# 14  can't update SELinux user mapping

# 0   success
# 1   can't update password file
# 2   invalid command syntax
# 3   invalid argument to option
# 4   UID already in use (and no -o)
# 6   specified group doesn't exist
# 9   username already in use
# 10  can't update group file
# 12  can't create home directory
# 14  can't update SELinux user mapping

> /tmp/local_ip.txt
/sbin/ip a | grep "inet "|awk '{print $2}'|awk -F / '{print $1}' > /tmp/local_ip.txt
for i in `cat /tmp/hosts.txt`;do
        for j in `cat /tmp/local_ip.txt`;do
                [ "$i" = "$j" ] && IP=$i && break 2
        done
done

# if basicgroup not exist,create this group
if [ "$BASICGID" ];then
  GROUPNAME=`cat /etc/group|awk -F: '{print $1}'|grep $BASICGID`
  if [ "$BASICGID" != "$GROUPNAME" ];then
     groupadd $BASICGID 
  fi
  BASICGID=`grep ^$BASICGID /etc/group|awk -F: '{print $3}'`   
fi

# Check if MYNAME was given
if [ ! "$MYNAME" ];then
   RESULT=error
   OUTPUT="you should give MYNAME a value"
   echo -e "$IP\t$RESULT\t\t$OUTPUT" > /tmp/$DATE
   exit
fi

# Check if UID is a number.
if [ "$MYUID" ];then
  re='^[0-9]+$'
  if ! [[ $MYUID =~ $re ]] ; then
    RESULT=error
    OUTPUT="UID should be a number."
    echo -e "$IP\t$RESULT\t\t$OUTPUT" > /tmp/$DATE
    exit
  fi
fi

# Check if home directory is in good format.
if [ "$MYHOME" ];then
  re='^/.*$'
  if ! [[ $MYHOME =~ $re ]] ; then
    RESULT=error
    OUTPUT="The home directory should start with /."
    echo -e "$IP\t$RESULT\t\t$OUTPUT" > /tmp/$DATE
    exit 
  fi
fi

# Check if login shell file exists.
if [ "$MYSHELL" ];then
  if [ ! -x $MYSHELL ]; then
    RESULT=error
    OUTPUT="The login shell does not exist."
    echo -e "$IP\t$RESULT\t\t$OUTPUT" > /tmp/$DATE
    exit
  fi
fi

CMD="/usr/sbin/useradd $MYNAME"
if [ "$MYUID" -a "$BASICGID" -a "$MYGID" -a "$MYHOME" -a "$MYSHELL" ];then $CMD -u $MYUID -g $BASICGID -G $MYGID -d $MYHOME -s $MYSHELL;
elif [ "$MYUID" -a "$BASICGID" -a "$MYGID" -a "$MYHOME" ];then $CMD -u $MYUID -g $BASICGID -G $MYGID -d $MYHOME ;
elif [ "$MYUID" -a "$BASICGID" -a "$MYGID" -a "$MYSHELL" ];then $CMD -u $MYUID -g $BASICGID -G $MYGID -s $MYSHELL;
elif [ "$MYUID" -a "$BASICGID" -a "$MYHOME" -a "$MYSHELL" ];then $CMD -u $MYUID -g $BASICGID -d $MYHOME -s $MYSHELL;
elif [ "$MYUID" -a "$MYGID" -a "$MYHOME" -a "$MYSHELL" ];then $CMD -u $MYUID -G $MYGID -d $MYHOME -s $MYSHELL;
elif [ "$BASICGID" -a "$MYGID" -a "$MYHOME" -a "$MYSHELL" ];then $CMD -g $BASICGID -G $MYGID -d $MYHOME -s $MYSHELL;
elif [ "$MYUID" -a "$BASICGID" -a "$MYGID" ];then $CMD -u $MYUID -g $BASICGID -G $MYGID;
elif [ "$MYUID" -a "$BASICGID" -a "$MYHOME" ];then $CMD -u $MYUID -g $BASICGID -d $MYHOME;
elif [ "$MYUID" -a "$BASICGID" -a "$MYSHELL" ];then $CMD -u $MYUID -g $BASICGID -s $MYSHELL;
elif [ "$MYUID" -a "$MYGID" -a "$MYHOME" ];then $CMD -u $MYUID -G $MYGID -d $MYHOME;
elif [ "$MYUID" -a "$MYGID" -a "$MYSHELL" ];then $CMD -u $MYUID -G $MYGID -s $MYSHELL;
elif [ "$MYUID" -a "$MYHOME" -a "$MYSHELL" ];then $CMD -u $MYUID -d $MYHOME -s $MYSHELL;
elif [ "$BASICGID" -a "$MYGID" -a "$MYHOME" ];then $CMD -g $BASICGID -G $MYGID -d $MYHOME;
elif [ "$BASICGID" -a "$MYGID" -a "$MYSHELL" ];then $CMD -g $BASICGID -G $MYGID -s $MYSHELL;
elif [ "$BASICGID" -a "$MYHOME" -a "$MYSHELL" ];then $CMD -g $BASICGID -d $MYHOME -s $MYSHELL;
elif [ "$MYGID" -a "$MYHOME" -a "$MYSHELL" ];then $CMD -G $MYGID -d $MYHOME -s $MYSHELL;
elif [ "$MYUID" -a "$BASICGID" ];then $CMD -u $MYUID -g $BASICGID;
elif [ "$MYUID" -a "$MYGID" ];then $CMD -u $MYUID -G $MYGID;
elif [ "$MYUID" -a "$MYHOME" ];then $CMD -u $MYUID -d $MYHOME;
elif [ "$MYUID" -a "$MYSHELL" ];then $CMD -u $MYUID -s $MYSHELL;
elif [ "$BASICGID" -a "$MYGID" ];then $CMD -g $BASICGID -G $MYGID;
elif [ "$BASICGID" -a "$MYHOME" ];then $CMD -g $BASICGID -d $MYHOME;
elif [ "$BASICGID" -a "$MYSHELL" ];then $CMD -g $BASICGID -s $MYSHELL;
elif [ "$MYGID" -a "$MYHOME" ];then $CMD -G $MYGID -d $MYHOME;
elif [ "$MYGID" -a "$MYSHELL" ];then $CMD -G $MYGID -s $MYSHELL;
elif [ "$MYHOME" -a "$MYSHELL" ];then $CMD -d $MYHOME -s $MYSHELL;
elif [ "$MYUID" ];then $CMD -u $MYUID;
elif [ "$BASICGID" ];then $CMD -g $BASICGID;
elif [ "$MYGID" ];then $CMD -G $MYGID;
elif [ "$MYHOME" ];then $CMD -d $MYHOME;
elif [ "$MYSHELL" ];then $CMD -s $MYSHELL;
else $CMD;
fi

VARS=$?
case $VARS in 
0)
 RESULT=success
 OUTPUT="add user $MYNAME"
 if [ "$MYPASSWD" ];then
 echo "$MYPASSWD" | passwd --stdin $MYNAME > /tmp/passwd 2>&1
   if [ $? -ne 0  ];then
     OUTPUT=`cat /tmp/passwd`
     RESULT="add passwd fail"
   fi
 fi
;;
1)
 RESULT=error
 OUTPUT="can't update password file"
;;
2)
 RESULT=error
 OUTPUT="invalid command syntax"
;;
3)
 RESULT=error
 OUTPUT="invalid argument to option"
;;
4)
 RESULT=error
 OUTPUT="UID already in use (and no -o)"
;;
6)
 RESULT=error
 OUTPUT="specified group $BASICGID $MYGID doesn't exist"
;;
9)
 RESULT=error
 OUTPUT="username $MYNAME already in use"
;;
10)
 RESULT=error
 OUTPUT="can't update group file"
;;
12)
 RESULT=error
 OUTPUT="can't create home directory"
;;
14)
 RESULT=error
 OUTPUT="can't update SELinux user mapping"
;;
esac

exec > /tmp/$DATE
echo "$IP\t$RESULT\t\t$OUTPUT"

