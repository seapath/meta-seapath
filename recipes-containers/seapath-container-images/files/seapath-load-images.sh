#!/bin/sh
set -e

BUNDLES_DIR="/usr/share/container-bundles/podman/oci"
REFS_FILE="/usr/share/container-bundles/podman/seapath-container-images.refs"
IMPORT_FLAG="/mnt/persistent/.seapath-images-imported"

if [ -f "$IMPORT_FLAG" ]; then
    echo "seapath-load-images: images already imported, skipping."
    exit 0
fi

if [ ! -f "$REFS_FILE" ]; then
    echo "seapath-load-images: no refs file at $REFS_FILE"
    exit 1
fi

while IFS=: read -r oci_name image_ref; do
    [ -z "$oci_name" ] && continue
    oci_path="${BUNDLES_DIR}/${oci_name}"
    if [ -d "$oci_path" ]; then
        echo "seapath-load-images: importing ${image_ref} ..."
        /usr/sbin/skopeo copy "oci:${oci_path}" "containers-storage:${image_ref}"
    else
        echo "seapath-load-images: WARNING: OCI dir not found: ${oci_path}"
    fi
done < "$REFS_FILE"

touch "$IMPORT_FLAG"
echo "seapath-load-images: import complete."
