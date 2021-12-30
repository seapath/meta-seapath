#!/bin/sh
if [ "$1" == "xml" ]
then
  /usr/sbin/crm_mon --output-as xml | tr -d '\n' | sed -r 's/>[ ]+</></g'
else
  crm status
fi
