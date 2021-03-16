do_install_append() {
    install -d ${D}${sysconfdir}/systemd/system/sysinit.target.wants
    lnr ${D}/lib/systemd/system/systemd-time-wait-sync.service ${D}${sysconfdir}/systemd/system/sysinit.target.wants/systemd-time-wait-sync.service

    #systemd-time-wait-sync hangs if it is started before /var/lib is mounted
    sed -i -E "s/^Wants=(.*)/Wants=\1\nAfter=var-lib.mount/" ${D}/lib/systemd/system/systemd-time-wait-sync.service
}

FILES_${PN} += "${sysconfdir}/systemd/system/sysinit.target.wants/systemd-time-wait-sync.service"
