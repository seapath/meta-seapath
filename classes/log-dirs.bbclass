# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

#
# Creates log directories creation services for hardened services
#

LOG_DIRS_LIST ?= ""

do_install_append() {
  for dir in ${LOG_DIRS_LIST}; do
    cat << EOF > ${D}${systemd_unitdir}/system/create-$dir-log-dir.service
# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

[Unit]
DefaultDependencies=no
RequiresMountsFor=/var/log
ConditionPathIsReadWrite=/var/log
After=local-fs.target

[Service]
Type=oneshot
ExecStart=/bin/mkdir -p /var/log/$dir

[Install]
WantedBy=$dir.service
EOF
  done
}

python() {
  dir_list = d.getVar("LOG_DIRS_LIST").split()
  for dir in dir_list:
    service_name = " create-" + str(dir) + "-log-dir.service"
    service_file = " ${systemd_unitdir}/system/" + service_name[1:]
    d.appendVar("SYSTEMD_SERVICE_" + d.getVar('PN'), service_name)
    d.appendVar("FILES_" + d.getVar('PN'), service_file)
}

