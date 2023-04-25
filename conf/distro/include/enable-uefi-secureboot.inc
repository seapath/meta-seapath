# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

# Configuration to use meta-secure-core layer signing facilities
# to implement UEFI SecureBoot.

# Set the UEFI SecureBoot feature
DISTRO_FEATURES:append = " efi-secure-boot"

# Controls whether the signing is using samples or real keys
SIGNING_MODEL = "user"

# Directories where Secureboot certs will be stored.
# UEFI_SECUREBOOT_KEYS_DIR is defined in the layer
# configuration.
UEFI_SB_KEYS_DIR = "${UEFI_SECUREBOOT_KEYS_DIR}/uefi-sb-keys"

# Enable UEFI SecureBoot signing
UEFI_SB = "1"

# Do not use MOK protocol as SEAPATH is intended to be installed
# on systems where the installer can overwrite UEFI SecureBoot
# DB/DBX/KEK/PK variables without needing shim.
MOK_SB = "0"

# Use SELoader for GRUB to sign any artifact with SecureBoot keys
# and allow propagation of SecureBoot chain up to the kernel.
UEFI_SELOADER = "1"

# GPG signing will not be used as the GRUB is supposed to
# be a static binary and kernel will be signed and verified
# by SELoader.
GRUB_SIGN_VERIFY = "0"
GRUB_SIGN_VERIFY_STRICT = "0"

# Set signed files into the appropriate boot folder
EFI_BOOT_PATH = "/boot/EFI/BOOT"

# Set correct ESP partition target path for SELoader and
# OVMF DXE drivers
EFI_TARGET:pn-seloader = "${EFI_BOOT_PATH}"
EFI_TARGET:pn-ovmf = "${EFI_BOOT_PATH}"
