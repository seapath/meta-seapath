#!/bin/sh

nodes_path=/sys/devices/system/node/
if [ ! -d $nodes_path ]; then
  echo "ERROR: $nodes_path does not exist"
  exit 1
fi

hugepages_number_file=/etc/hugepages_nb.conf

reserve_pages()
{
  if [ -f $hugepages_number_file ]; then
    cat $hugepages_number_file > \
    $nodes_path/$1/hugepages/hugepages-1048576kB/nr_hugepages
  else
    echo 1 > $nodes_path/$1/hugepages/hugepages-1048576kB/nr_hugepages
  fi
}

reserve_pages node0
