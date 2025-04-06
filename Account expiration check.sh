#!/bin/bash

threshold=7

for i in $(awk 'BEGIN{ FS= ":"}{ if ($3 >= 1000 && $3 != 65534) {print $1}}' /etc/passwd)
do
   exp=$(chage -l "$i" | grep "Account expires" | awk '{print $4, $5, $6}' | xargs)

   if [[ "$exp" != "never" ]] || [[ -z "$exp" ]]
   then

      exp_sec=$(date -d "$exp" +%s)
      current_date_sec=$(date +%s)
      x=$(( (exp_sec - current_date_sec) / 86400 ))

      if [[ "$x" -le "$threshold" ]]
      then
          echo "User $i's account will expire in $exp"
      fi

   else
        echo "User $i's account has no expiration or never expires."
   fi

done

#86400 : number of seconds in one day
#xargs to  ensures that any extra spaces in the expiration date string are removed before processing.
# -z to check (is empty string)
