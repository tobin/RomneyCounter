#!/bin/sh

while true; do
  ((date +"%s" | tr "\n" " ") ; (wget --quiet -O - graph.facebook.com/barackobama | grep -E -o "\"likes\":[0-9]*" | grep -E -o "[0-9]+")) | tee -a obamacount.txt
  sleep 600
done
