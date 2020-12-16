#FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

do_install_append() {
    #start systemd-networkd after overlayfs /etc is mounted
    #sed -i -E "s/^After=(.+)/After=\1 etc.mount/" ${D}/${systemd_system_unitdir}/systemd-networkd.service
}
