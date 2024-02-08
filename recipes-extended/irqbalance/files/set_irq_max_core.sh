#!/bin/bash -e

MAX_CPU_CORE=$(($(nproc --all) - 1))
CPU_BAN_LIST=$(grep 'IRQBALANCE_BANNED_CPULIST' /etc/irqbalance.env | awk -F= '{print $2}')

if echo "$CPU_BAN_LIST" | grep -q 'N'; then
    CPU_BAN_LIST=$(echo $CPU_BAN_LIST | sed "s/N/$MAX_CPU_CORE/")
    echo "IRQBALANCE_BANNED_CPULIST=$CPU_BAN_LIST" > /etc/irqbalance.env
fi
