FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://var-log-journal.mount"

do_install_append() {
    #persistent journal
    if ${@bb.utils.contains('DISTRO_FEATURES', 'persistent-journal', 'true', 'false', d)}; then
        sed -i -E 's/^After=(.*)$/After=\1 etc.mount var-log-journal.mount/' ${D}/lib/systemd/system/systemd-journald.service
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
    fi
}

FILES_${PN} += "${@bb.utils.contains('DISTRO_FEATURES', 'persistent-journal', '/mnt/data/journal ${systemd_system_unitdir}/var-log-journal.mount', '', d)}"
SYSTEMD_SERVICE_${PN} += "${@bb.utils.contains('DISTRO_FEATURES', 'persistent-journal', 'var-log-journal.mount', '', d)}"
