EXTRA_OECMAKE_append = " -DENABLE_GIT_VERSION=OFF"

def limit_parallel(limit):
   import multiprocessing
   nproc = min(multiprocessing.cpu_count(), int(limit))
   return "-j{}".format(nproc)

PARALLEL_MAKE = "${@limit_parallel(8)}"
