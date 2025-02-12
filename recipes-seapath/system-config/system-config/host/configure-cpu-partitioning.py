#!/usr/bin/env python3

import glob


# Expend a kernel CPU list 0-3,7,9-11 will convert to [0,1,2,3,7,9,10,11]
def kernel_cpulist_expend(cpulist):
    cpulist = cpulist.split(",")
    cpulist = [x.split("-") for x in cpulist]
    cpulist = [
        list(range(int(x[0]), int(x[1]) + 1)) if len(x) == 2 else [int(x[0])]
        for x in cpulist
    ]
    cpulist = [str(x) for sublist in cpulist for x in sublist]
    return cpulist


def invert_cpulist(cpulist, max_cpus):
    cpulist = [int(x) for x in cpulist]
    cpulist = [x for x in range(max_cpus + 1) if x not in cpulist]
    return cpulist


def read_sysfs_file(filename):
    with open(filename, "r") as f:
        return f.read().strip()


def write_sysfs_file(filename, value):
    with open(filename, "w") as f:
        f.write(value)


def get_max_cpus():
    return int(
        read_sysfs_file("/sys/devices/system/cpu/possible").split("-")[-1]
    )


def get_isolated_cpus():
    r = read_sysfs_file("/sys/devices/system/cpu/isolated")
    if r == "":
        return []
    else:
        return kernel_cpulist_expend(r)


def get_none_isolated_cpus():
    max_cpus = get_max_cpus()
    isolated_cpus = get_isolated_cpus()
    return invert_cpulist(isolated_cpus, max_cpus)


def cpulist_to_mask(cpulist):
    mask = 0
    for cpu in cpulist:
        mask |= 1 << cpu
    return f'{mask:x}'


def main():
    not_isolated_cpumask = cpulist_to_mask(get_none_isolated_cpus())
    for file in [
        "/sys/bus/workqueue/devices/writeback/cpumask",
        "/sys/devices/virtual/workqueue/cpumask",
    ] + glob.glob("/sys/devices/virtual/workqueue/*/cpumask"):
        print(f"Setting {file} cpumask to: {not_isolated_cpumask}")
        write_sysfs_file(file, not_isolated_cpumask)
    for file in glob.glob(
        "/sys/devices/system/machinecheck/machinecheck*/ignore_ce"
    ):
        print(f"Setting {file} to 1")
        write_sysfs_file(file, "1")


if __name__ == "__main__":
    main()
