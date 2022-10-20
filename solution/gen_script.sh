#!/bin/bash

if [[ ! -f ./inputdata ]]
then
  touch inputdata
  export startIndex=0
else
  startFrom=$(tail -n 1 inputdata | awk '{print $1}' | sed 's/,//')
  export startIndex=$((startFrom+1))
fi

if [[ -z $1 ]]
then
  export entriesCount=10
else
  export entriesCount=$1
fi

for (( index=$startIndex; index < $((startIndex+entriesCount)); index++ ));do
  echo "$index, $(($RANDOM%100 + 100))">> inputdata
done
