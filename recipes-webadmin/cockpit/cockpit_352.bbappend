do_install:append () {
    # Fix malformed shebang
    sed 's/python3import/python3\nimport/g' -i ${D}${bindir}/cockpit-bridge
}
