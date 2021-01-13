do_install_append() {
    install -d ${D}${sysconfdir}/systemd/system/sysinit.target.wants
    lnr ${D}/lib/systemd/system/systemd-time-wait-sync.service ${D}${sysconfdir}/systemd/system/sysinit.target.wants/systemd-time-wait-sync.service
}

FILES_${PN} += "${sysconfdir}/systemd/system/sysinit.target.wants/systemd-time-wait-sync.service"