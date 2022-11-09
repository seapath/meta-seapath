#!/bin/bash

# Copyright (C) 2022, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

FILE=/tmp/guest_diskusage.txt

function create_or_rewrite {
  /usr/libexec/virt-df.sh > $FILE
}

if [ -f $FILE ]
then
  OLDTIME=3600
  CURTIME=$(date +%s)
  FILETIME=$(stat $FILE -c %Y)
  TIMEDIFF=$(expr $CURTIME - $FILETIME)

  if [ $TIMEDIFF -gt $OLDTIME ]; then
    create_or_rewrite
  fi
else
  create_or_rewrite
fi
cat $FILE
