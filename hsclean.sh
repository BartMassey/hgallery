#!/bin/sh
# Copyright © 2014 Bart Massey

# For the purposes of this work, this file is licensed
# under the GNU AGPL v3. Please see the file COPYING in
# this distribution for license terms.

VERBOSE=false
case "$1" in
-v)  VERBOSE=true; shift ;;
esac
case $# in
0) set *.hs ;;
esac

for i in "$@"
do
  j="`basename $i .hs`"
  $VERBOSE && echo "$j"
  for ext in hi o s ps hp prof aux hcr
  do 
    rm -f "$j".$ext
  done
  [ -f "$j" ] && rm -f "$j"
done
exit 0
