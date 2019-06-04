#!/bin/bash

NUM=0
> /output/01_useradd_result_$DATE

echo -e "No.\tIP\t\tResult\t\tOutput" >> /output/01_useradd_result_$DATE

for i in `ls /output/*/useradd_$DATE`
do
  NUM=`expr $NUM + 1`
  RESULT=`cat $i`
  echo -e "$NUM\t$RESULT" >> /output/01_useradd_result_$DATE
done

NUM=0
RESULT=
