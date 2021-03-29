FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://var-log-journal.mount"

do_install_append() {

    #persistent journal
    if ${@bb.utils.contains('DISTRO_FEATURES', 'persistent-journal', 'true', 'false', d)}; then
        sed -i -E 's/^Requires=(.*)$/Requires=\1 var-log-journal.mount/' ${D}${systemd_system_unitdir}/systemd-journald.service
        sed -i -E 's/^After=(.*)$/After=\1 etc.mount var-log-journal.mount systemd-machine-id-commit.service/' ${D}${systemd_system_unitdir}/systemd-journald.service
        sed -i 's/^#Storage=auto/Storage=persistent/' ${D}${sysconfdir}/systemd/journald.conf

        [ ! -z ${JOURNALD_SystemMaxUse} ]       && sed -i 's/^#SystemMaxUse=/SystemMaxUse=${JOURNALD_SystemMaxUse} /' ${D}${sysconfdir}/systemd/journald.conf
        [ ! -z ${JOURNALD_SystemKeepFree} ]     && sed -i 's/^#SystemKeepFree=/SystemKeepFree=${JOURNALD_SystemKeepFree} /' ${D}${sysconfdir}/systemd/journald.conf
        [ ! -z ${JOURNALD_SystemMaxFileSize} ]  && sed -i 's/^#SystemMaxFileSize=/SystemMaxFileSize=${JOURNALD_SystemMaxFileSize} /' ${D}${sysconfdir}/systemd/journald.conf
        [ ! -z ${JOURNALD_SystemMaxFiles} ]     && sed -i 's/^#SystemMaxFiles=/SystemMaxFiles=${JOURNALD_SystemMaxFiles} /' ${D}${sysconfdir}/systemd/journald.conf
        [ ! -z ${JOURNALD_RuntimeMaxUse} ]      && sed -i 's/^#RuntimeMaxUse=/RuntimeMaxUse=${JOURNALD_RuntimeMaxUse} /' ${D}${sysconfdir}/systemd/journald.conf
        [ ! -z ${JOURNALD_RuntimeKeepFree} ]    && sed -i 's/^#RuntimeKeepFree=/RuntimeKeepFree=${JOURNALD_RuntimeKeepFree} /' ${D}${sysconfdir}/systemd/journald.conf
        [ ! -z ${JOURNALD_RuntimeMaxFileSize} ] && sed -i 's/^#RuntimeMaxFileSize=/RuntimeMaxFileSize=${JOURNALD_RuntimeMaxFileSize} /' ${D}${sysconfdir}/systemd/journald.conf
        [ ! -z ${JOURNALD_RuntimeMaxFiles} ]    && sed -i 's/^#RuntimeMaxFiles=/RuntimeMaxFiles=${JOURNALD_RuntimeMaxFiles} /' ${D}${sysconfdir}/systemd/journald.conf

        install -m 1750 -d ${D}/mnt/data/journal
        chgrp systemd-journal ${D}/mnt/data/journal
        install -m 0644 ${WORKDIR}/var-log-journal.mount ${D}${systemd_system_unitdir}/

        # (Re)create journal folder permissions in data partions, e.g. after a
        # factory reset via tmpfiles.d.
        # (https://www.freedesktop.org/software/systemd/man/tmpfiles.d.html).
        #
        # We need that for scenarios where you update from an image without
        # persistent journal to an image where persistent journal is enabled.
        # Note: /mnt/data/journal is implicitly created by
        #       'var-log-journal.mount'.
        echo "z /mnt/data/journal 2750 root systemd-journal - -"                    >> ${D}${libdir}/tmpfiles.d/persistent_journal.conf
        echo "z /mnt/data/journal/%m 2755 root systemd-journal - -"                 >> ${D}${libdir}/tmpfiles.d/persistent_journal.conf
        echo "z /mnt/data/journal/%m/system.journal 0640 root systemd-journal - -"  >> ${D}${libdir}/tmpfiles.d/persistent_journal.conf

        # Enable persistent machine-id creation only if journal is persistent
        # Note: We can not simply create an etc-machine\x2did.mount unit.
        #       Systemd creates a tmpfs mtab entry for /etc/machine-id which
        #       prevents that we can mount /etc/machine-id with
        #       "Where=" in etc-machine\x2did.mount.
        #       Thus we do it as "ExecStartPre=" step in
        #       systemd-machine-id-commit.service.
        sed -i -E '/^ConditionPathIsMountPoint=(.*)/d' ${D}${systemd_system_unitdir}/systemd-machine-id-commit.service
        sed -i -E 's?^ConditionPathIsReadWrite=(.*)?ConditionPathExists=!/mnt/etc/upper/machine-id?' ${D}${systemd_system_unitdir}/systemd-machine-id-commit.service
        sed -i -E 's?^ExecStart=(.*)?ExecStartPre=touch /mnt/etc/upper/machine-id\nExecStartPre=mount -o bind /mnt/etc/upper/machine-id /etc/machine-id\nExecStart=/bin/systemd-machine-id-setup?' ${D}${systemd_system_unitdir}/systemd-machine-id-commit.service
    fi

    # Start systemd-timesync after '/var/lib' is mounted rw.
    # Even if it can not sync via ntp it will set the last saved time from
    # '/var/lib/systemd/timesync/clock'.
    sed -i -E 's/^After=(.*)$/After=\1 var-lib.mount/' ${D}${systemd_system_unitdir}/systemd-timesyncd.service
}

FILES_${PN} += " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'persistent-journal', '/mnt/data/journal ${systemd_system_unitdir}/var-log-journal.mount', '', d)} \
    "

SYSTEMD_SERVICE_${PN} += " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'persistent-journal', 'var-log-journal.mount systemd-machine-id-commit.service', '', d)} \
    "
