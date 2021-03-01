do_install_append() {
    install -d ${D}${sysconfdir}/systemd/system/sysinit.target.wants
    lnr ${D}/lib/systemd/system/systemd-time-wait-sync.service ${D}${sysconfdir}/systemd/system/sysinit.target.wants/systemd-time-wait-sync.service

    #systemd-time-wait-sync hangs if it is started before /var/lib is mounted
    sed -i -E "s/^Wants=(.*)/Wants=\1\nAfter=var-lib.mount/" ${D}/lib/systemd/system/systemd-time-wait-sync.service

    #persistent journal
    if ${@bb.utils.contains('DISTRO_FEATURES', 'persistent-journal', 'true', 'false', d)}; then
        sed -i -E 's/^After=(.*)$/After=\1 etc.mount mnt-data.mount/' ${D}/lib/systemd/system/systemd-journald.service
        sed -i 's/^#Storage=auto/Storage=persistent/' ${D}${sysconfdir}/systemd/journald.conf

        [ ! -z ${JOURNALD_SystemMaxUse} ]       && sed -i 's/^#SystemMaxUse=/SystemMaxUse=${JOURNALD_SystemMaxUse} /' ${D}${sysconfdir}/systemd/journald.conf
        [ ! -z ${JOURNALD_SystemKeepFree} ]     && sed -i 's/^#SystemKeepFree=/SystemKeepFree=${JOURNALD_SystemKeepFree} /' ${D}${sysconfdir}/systemd/journald.conf
        [ ! -z ${JOURNALD_SystemMaxFileSize} ]  && sed -i 's/^#SystemMaxFileSize=/SystemMaxFileSize=${JOURNALD_SystemMaxFileSize} /' ${D}${sysconfdir}/systemd/journald.conf
        [ ! -z ${JOURNALD_SystemMaxFiles} ]     && sed -i 's/^#SystemMaxFiles=/SystemMaxFiles=${JOURNALD_SystemMaxFiles} /' ${D}${sysconfdir}/systemd/journald.conf
        [ ! -z ${JOURNALD_RuntimeMaxUse} ]      && sed -i 's/^#RuntimeMaxUse=/RuntimeMaxUse=${JOURNALD_RuntimeMaxUse} /' ${D}${sysconfdir}/systemd/journald.conf
        [ ! -z ${JOURNALD_RuntimeKeepFree} ]    && sed -i 's/^#RuntimeKeepFree=/RuntimeKeepFree=${JOURNALD_RuntimeKeepFree} /' ${D}${sysconfdir}/systemd/journald.conf
        [ ! -z ${JOURNALD_RuntimeMaxFileSize} ] && sed -i 's/^#RuntimeMaxFileSize=/RuntimeMaxFileSize=${JOURNALD_RuntimeMaxFileSize} /' ${D}${sysconfdir}/systemd/journald.conf
        [ ! -z ${JOURNALD_RuntimeMaxFiles} ]    && sed -i 's/^#RuntimeMaxFiles=/RuntimeMaxFiles=${JOURNALD_RuntimeMaxFiles} /' ${D}${sysconfdir}/systemd/journald.conf

        install -m 775 -d ${D}/mnt/data/journal
        chgrp systemd-journal ${D}/mnt/data/journal
        rmdir ${D}${localstatedir}/log/journal
        lnr ${D}/mnt/data/journal ${D}${localstatedir}/log/journal
    fi
}

FILES_${PN} += "${sysconfdir}/systemd/system/sysinit.target.wants/systemd-time-wait-sync.service /mnt/data/journal"
