# GCC records absolute kernel plugin paths in DW_AT_producer by default.
EXTRA_OEMAKE:append = " KCFLAGS='-gno-record-gcc-switches'"
