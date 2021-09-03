#!/bin/bash
declare -a arr=("192.168.8.4" "192.168.8.1" "192.168.8.6")

suffix= date +%m-%d-%y
rm -rf /home/calinux/Desktop/ap-checker/ap-checker.body
printf "Subject: [Annex] AP report\n" >> ap-checker.body
printf "From: msdfotontest@gmail.com\n" >> ap-checker.body
printf "Content-type: text/html; charset='utf8'\n" >> ap-checker.body
printf "<html>\n" >> ap-checker.body
printf "<body>\n" >> ap-checker.body
printf "<h1>AP Reports</h1>\n" >> ap-checker.body

ping_result=""

for i in "${arr[@]}"
do
    printf $i 
    ping -c 1 $i
    if [ $? -eq 0 ]; then
       printf "<p>"$i" is okay</p>\n"
    else
       printf "<p>"$i" is offline please check</p>\n"  >> ap-checker.body
fi
done

printf "</body>\n" >> ap-checker.body
printf "</html>" >> ap-checker.body 

checker=$(grep -n 'is offline' ap-checker.body | gawk '{print $1}' FS=":" | head -1)
if [[ $checker -gt 0 ]] 
then
	printf "AP not working found" | sendmail -v caicatar@foton.com.ph < ap-checker.body
else
   printf "\nNo error\n"
fi