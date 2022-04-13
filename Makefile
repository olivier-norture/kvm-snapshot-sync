SNAPSHOT_NAME="desktop-2022-04-13"

.PHONY: ultra-create-snapshot
ultra-create-snapshot:
#               --memspec file=/run/media/olivier/Data2/VMs/ultra-ram-snap-${SNAPSHOT_NAME}.qcow2,snapshot=external
        sudo virsh snapshot-create-as archlinux-ultra \
                --name ${SNAPSHOT_NAME} \
                --diskspec vda,snapshot=external,file=/run/media/olivier/Data2/VMs/ultra-system-snap-${SNAPSHOT_NAME}.qcow2 \
                --diskspec vdb,snapshot=external,file=/run/media/olivier/Data2/VMs/ultra-home-snap-${SNAPSHOT_NAME}.qcow2 \
                --atomic \
                --disk-only


.PHONY: ultra-export-xml
ultra-export-xml:
        sudo virsh dumpxml archlinux-ultra --security-info --migratable > archlinux.xml

.PHONY: ultra-export-xml-snapshot
ultra-export-xml-snapshot:
        sudo virsh dumpxml

