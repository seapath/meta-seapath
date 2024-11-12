# It is not the role of the meta-aaeon to install these files

do_install:append () {
  rm -f ${D}/etc/issue
  rm -f ${D}/etc/issue.net
  rm -f ${D}/etc/os-release
}
