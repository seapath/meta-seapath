DESCRIPTION = "Test distributed files storage"
LICENSE = "CLOSED"

inherit pkgconfig cmake
DEPENDS = "glib-2.0"

PR = "r0"
S = "${WORKDIR}/"

SRC_URI = "file://CMakeLists.txt;md5=b737bcadc49032e02959df8d095e7ec5 \
           file://test_sync_storage_result.c;md5=04731f6b41f6215b5287f86e6840335c \
           file://test_sync_storage_write.c;md5=4e8af9b2de1c0edeba6f6d90e76da21a"



FILES_${PN} = "${bindir}/test_sync_storage_result \
              ${bindir}/test_sync_storage_write"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 test_sync_storage_result ${D}${bindir}
    install -m 0755 test_sync_storage_write ${D}${bindir}
}
