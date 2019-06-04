# 0     成功
# 1     无法更新密码文件
# 2     无效的命令语法
# 6     指定的用户不存在
# 8     用户已经登录
# 10    无法更新组文件
# 12    无法删除主目录

# 0     success
# 1     can't update password file
# 2     invalid command syntax
# 6     specified user doesn't exist
# 8     user currently logged in
# 10    can't update group file
# 12    can't remove home directory

LANG=

> /tmp/local_ip.txt
/sbin/ip a | grep "inet "|awk '{print $2}'|awk -F / '{print $1}' > /tmp/local_ip.txt
for i in `cat /tmp/hosts.txt`;do
        for j in `cat /tmp/local_ip.txt`;do
                [ "$i" = "$j" ] && IP=$i && break 2
        done
done

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
if [ ! "$MYNAME" -a ! "$MYUID"  ];then
    OUTPUT="error"
    RESULT="none args,choose MYNAME or MYUID"
    echo -e "$IP\t$OUTPUT\t$RESULT" > /tmp/$DATE
    exit
fi

# if vars was given to much values
if [ "$MYNAME" -a "$MYUID"  ];then
    OUTPUT="error"
    RESULT="too much args,choose MYNAME or MYUID"
    echo -e "$IP\t$OUTPUT\t$RESULT" > /tmp/$DATE
    exit
fi

if [ "$MYHOME" != "yes" -a "$MYHOME" != "no" ];then
    OUTPUT="error"
    RESULT="MYHOME must be yes or no"
    echo -e "$IP\t$OUTPUT\t$RESULT" > /tmp/$DATE
    exit
fi

# if vars  MYNAME was given a value,delete user MYNAME
if [ "$MYNAME" -a "$MYHOME" == "yes" ];then
  /usr/sbin/userdel -r $MYNAME
elif [ "$MYNAME" -a "$MYHOME" == "no" ];then
  /usr/sbin/userdel $MYNAME
  VARS=$?
  case $VARS in
  0)
   RESULT=success
   OUTPUT="delete user $MYNAME"
  ;;
  1)
   RESULT=error
   OUTPUT="can't update $MYNAME's password file"
  ;;
  2)
   RESULT=error
   OUTPUT="invalid command syntax"
  ;;
  6)
   RESULT=error
   OUTPUT="specified user $MYNAME doesn't exist"
  ;;
  8)
   RESULT=error
   OUTPUT="user $MYNAME currently logged in"
  ;;
  10)
   RESULT=error
   OUTPUT="can't update $MYNAME's group file"
  ;;
  12)
   RESULT=error
   OUTPUT="can't remove $MYNAME's home directory"
  ;;
  esac
  echo "$IP\t$RESULT\t\t$OUTPUT" > /tmp/$DATE
  exit
fi


# if vars  UID was given a value,delete user who's uid is MYUID
if [ "$MYUID" ];then
  MYNAME=`getent passwd $MYUID |awk -F : '{print $1}'`
  if [ "$MYNAME" -a "$MYHOME" == "yes" ];then
    /usr/sbin/userdel -r $MYNAME
  elif [ "$MYNAME" -a "$MYHOME" == "no" ];then
    /usr/sbin/userdel $MYNAME
  else
    RESULT=error
    OUTPUT="specified user who's uid is $MYUID doesn't exist"
    echo "$IP\t$RESULT\t\t$OUTPUT" > /tmp/$DATE
    exit
  fi
fi

VARS=$?
case $VARS in 
0)
 RESULT=success
 OUTPUT="delete user $MYNAME"
;;
1)
 RESULT=error
 OUTPUT="can't update $MYNAME's password file"
;;
2)
 RESULT=error
 OUTPUT="invalid command syntax"
;;
6)
 RESULT=error
 OUTPUT="specified user $MYNAME doesn't exist"
;;
8)
 RESULT=error
 OUTPUT="user $MYNAME currently logged in"
;;
10)
 RESULT=error
 OUTPUT="can't update $MYNAME's group file"
;;
12)
 RESULT=error
 OUTPUT="can't remove $MYNAME's home directory"
;;
esac

exec > /tmp/$DATE
echo "$IP\t$RESULT\t\t$OUTPUT"

