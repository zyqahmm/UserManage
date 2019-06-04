#!/bin/bash

NUM=0
> /output/01_userchk_result_$DATE

echo -e "No.\tIP\t\tResult\t\tOUTPUT\t\tid\t\t\t\t\t\t\thome\t\tshell" >> /output/01_userchk_result_$DATE

for i in `ls /output/*/userchk_$DATE`
do
  NUM=`expr $NUM + 1`
  RESULT=`cat $i`
  echo -e "$NUM\t$RESULT" >> /output/01_userchk_result_$DATE
done

NUM=0
RESULT=
