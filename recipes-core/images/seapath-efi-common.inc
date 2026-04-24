# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

inherit deploy
inherit boot-partition

IMAGE_INSTALL:remove = "grub"
IMAGE_INSTALL:append = " \
    grub-efi             \
    efitools             \
    efibootmgr           \
"

# Cockpit web GUI
COCKPIT_PACKAGES = " \
    cockpit \
    cockpit-bridge \
    ${@bb.utils.contains('DISTRO_FEATURES', 'seapath-clustering', 'cockpit-cluster-dashboard', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'seapath-clustering', 'cockpit-cluster-vm-management', '', d)} \
    cockpit-dashboard \
    cockpit-machines \
    cockpit-shell \
    cockpit-systemd \
    cockpit-update \
    cockpit-users \
    cockpit-ws \
"

IMAGE_INSTALL:append = "${@bb.utils.contains('DISTRO_FEATURES', 'seapath-cockpit', ' ${COCKPIT_PACKAGES}', '', d)}"

python do_generate_seapath_metadata(){
    # Add in the associated image BMAP file SEAPATH image metadata (name,
    # version, description and flavor).
    # These metadata are used by the SEAPATH installer.

    from pathlib import Path
    import xml.etree.ElementTree as ET
    import hashlib

    distro = d.getVar('DISTRO')

    if 'standalone' in distro:
        setup = 'Standalone'
    else:
        setup = 'Cluster'

    image_deploy_dir = Path(d.getVar('IMGDEPLOYDIR'))
    bmap_image_name = d.getVar('IMAGE_LINK_NAME')
    bmap_path = image_deploy_dir / f'{bmap_image_name}.wic.bmap'

    if not bmap_path.exists():
        bb.fatal('Missing bmap file: %s' % bmap_path)

    bmap_tree = ET.parse(str(bmap_path))
    root = bmap_tree.getroot()

    for tag, value in [
        ('ImageName',        d.getVar('PN')),
        ('ImageVersion',     d.getVar('DISTRO_VERSION')),
        ('ImageDescription', d.getVar('DESCRIPTION')),
        ('ImageSetup', setup),
        ('ImageFlavor', 'Yocto'),
    ]:
        node = ET.SubElement(root, tag)
        node.text = f' {value} '
        node.tail = '\n'


    # bmap-tools check for bmap file interity with a checksum computed
    # image build. As we modify the file we need to update the checksum
    # of the file:
    #   1. Reset the checksum to 0
    #   2. Compute the checksum of the file
    #   3. Replace with the new computed checksum
    bmap_file_checksum = root.find('BmapFileChecksum')
    len_bmap_file_checksum = len(str.strip(bmap_file_checksum.text))

    bmap_file_checksum.text = '0' * len_bmap_file_checksum
    root.tail = '\n'

    bmap_tree.write(str(bmap_path), encoding='utf-8', xml_declaration=False)

    checksum_type=root.find('ChecksumType')
    checksum_type_value = str.strip(checksum_type.text)

    block_size=root.find('BlockSize')
    block_size_value = int(str.strip(block_size.text))
    hash_obj = hashlib.new(str.strip(checksum_type.text))

    with open(bmap_path, 'rb') as file:
        while chunk := file.read(block_size_value):
            hash_obj.update(chunk)

    bmap_file_updated_hash = hash_obj.hexdigest()
    bmap_file_checksum.text = bmap_file_updated_hash
    root.tail = '\n'

    bmap_tree.write(str(bmap_path), encoding='utf-8', xml_declaration=False)
}

addtask do_generate_seapath_metadata before do_image_complete after do_image_wic
