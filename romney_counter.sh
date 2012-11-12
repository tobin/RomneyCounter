#!/bin/sh

while true; do
  ((date +"%s" | tr "\n" " ") ; (wget --quiet -O - graph.facebook.com/mittromney | grep -E -o "\"likes\":[0-9]*" | grep -E -o "[0-9]+")) | tee -a romneycount.txt
  sleep 300
done
