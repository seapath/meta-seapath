cmake_minimum_required(VERSION 3.1)

project(test_sync_storage)

find_package (PkgConfig REQUIRED)
pkg_check_modules (GLIB2 REQUIRED glib-2.0)
include_directories (${GLIB2_INCLUDE_DIRS})
link_directories (${GLIB2_LIBRARY_DIRS})
add_executable (test_sync_storage_write test_sync_storage_write.c)
add_executable (test_sync_storage_result test_sync_storage_result.c)
set(CMAKE_EXE_LINKER_FLAGS "-pie -Wl,-z,now -Wl,-z,defs -Wl,-z,relro")
add_definitions (${GLIB2_CFLAGS_OTHER} -O2 -D_FORTIFY_SOURCE=2
    -fstack-protector-strong -W -Wall -Werror -fPIE)
target_link_libraries (test_sync_storage_write ${GLIB2_LIBRARIES})
target_link_libraries (test_sync_storage_result ${GLIB2_LIBRARIES})

install(TARGETS test_sync_storage_write)
install(TARGETS test_sync_storage_result)
