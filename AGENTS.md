# meta-seapath Agent Notes

## Repository Context

- This is an independent Git repository inside the `repo`-managed BSP workspace. Run Git commands here for layer changes; consult [`../../AGENTS.md`](../../AGENTS.md) for source synchronization, CQFD, caches, and destructive build behavior.
- Builds must be launched from the BSP root two levels above. This layer has no standalone build environment or host-side unit-test runner.
- `conf/layer.conf` is compatible with `wrynose`, depends on the `efi-secure-boot` collection from `meta-secure-core`, and masks `meta-virtualization/recipes-extended/ceph` so this layer's Ceph recipes win. Preserve those cross-layer assumptions when changing dependencies.

## Focused Validation

- Configure the exact image tuple before running a focused BitBake command through root `build.sh`: host is `seapath-host-efi-image` / `seapath-host` / `seapath-hypervisor`; guest is `seapath-guest-efi-image` / `seapath-guest` / `seapath-vm`; flasher is `seapath-flasher` / `seapath-flash` / `seapath-installer`; observer is `seapath-observer-efi-image` / `seapath-host` / `seapath-observer`.
- Use `./build.sh -i <image> --distro <distro> --machine <machine> -- bitbake <recipe> -c <task>` from the BSP root for a focused recipe task. For image/include/class changes, build the smallest affected CQFD flavor instead because behavior is driven heavily by `DISTRO_FEATURES` and machine overrides.
- CI in this repository does not build locally; its workflows delegate to the main BSP repository. A green workflow therefore covers the root repository's image matrix, not a separate layer test command.

## Layer Conventions And Traps

- `classes/security/` controls users, PAM, read-only rootfs, Secure Boot QA, kernel hardening, SBOMs, and ELF `checksec` manifests. Security behavior is conditional on `seapath-security`; debug/no-security images deliberately allow unsafe login features and are not production equivalents.
- The compilation-hardening manifest can add more than an hour. Root `seapath.conf` normally sets `SEAPATH_SECCOMPILE_MANIFEST_SKIP=1`; only clear it when the change needs that report.
- Cukinia definitions live under `recipes-cukinia-tests/cukinia-tests/` and run from test images, not on the development host. IDs use `SEAPATH-XXXXX`; obtain the numeric part with `scripts/get-next-test-id <directory>` rather than guessing.
- Image recipes use `COMPATIBLE_MACHINE`; preserve the host/guest/flasher/observer split when adding images or includes. The installer is intentionally different: it uses `systemd-boot` and the 6.1 kernel while common host/guest machines prefer the 6.12 RT kernel.
- `conf/distro/include/seapath-common.inc` enforces static UID/GID tables and removes all `*-dev` packages. Changes to users, groups, or development packages require checking those global policies, not only the affected recipe.
- Keep the existing SPDX/copyright header style on new `.bb`, `.bbappend`, `.inc`, scripts, and source files.
- Generated WIC, SWUpdate, SBOM, kernel-hardening, and compilation reports land in the BSP root's `build/`; do not add generated artifacts to this repository.
