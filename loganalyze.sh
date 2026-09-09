#!/bin/bash

#Comment on local repo

#Comment on remote repo

#check for number of arguments
dir=$(pwd)
if [ $# -eq 1 ]; then
  if [ -d "$1" ]; then		    
     dir="$1"
  else
     echo -e "usage: arg needs to be a directory.\n"
     exit 1
  fi
elif [ $# -gt 1 ]; then
   echo -e "usage: more than 1 arg is not allowed.\n"
   exit 2
fi

echo "$dir"

#now look for log files in dir
files=$(find "$dir" -mindepth 1 -maxdepth 1 -type f -name "*log" -mtime -7)

#count
if [ -z "$files" ]; then
  numFiles=0
else
  numFiles=$(echo "$files" | wc -l)
  #echo $numFiles
fi
#echo "$files"

#check how many files you got
if [ $numFiles -eq 0 ]; then
   echo -e "No. of modified log files: 0\n"
   exit 0
else
   outFile=analysisData.log
   summaryFile=summary.log

   if [ -f "$outFile" ]; then
      	rm "$outFile"
   fi

   if [ -f "$summaryFile" ]; then
		rm "$summaryFile"
   fi

   total=0
   max=0
   maxFile="" 

   for file in $files
   do
      echo "******************"
      count=$(grep -ci "error" "$file")
      total=$(( total+count ))
	  echo -e "Filename: $file <No. of errors found = $count>" | tee -a "$outFile"
   
      if [ "$count" -gt "$max" ]; then
          max=$count
		  maxFile="$file"
      fi

   done

   echo "------------------"
   echo -e "Total errors found:$total" | tee -a "$summaryFile"
   echo -e "File with the max errors:$maxFile, <error-count:$max>" | tee -a "$summaryFile"
fi








 



