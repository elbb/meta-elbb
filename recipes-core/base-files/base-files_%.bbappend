FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://etc.mount file://mnt-etc.mount file://mnt-data.mount file://var-lib.mount file://home.mount"

do_install_append_rpi() {
  install -d ${D}${systemd_system_unitdir}
  install -m 0644 ${WORKDIR}/etc.mount ${D}${systemd_system_unitdir}/etc.mount
  install -m 0644 ${WORKDIR}/mnt-etc.mount ${D}${systemd_system_unitdir}/mnt-etc.mount
  install -m 0644 ${WORKDIR}/mnt-data.mount ${D}${systemd_system_unitdir}/mnt-data.mount
  install -m 0644 ${WORKDIR}/var-lib.mount ${D}${systemd_system_unitdir}/var-lib.mount
  install -m 0644 ${WORKDIR}/home.mount ${D}${systemd_system_unitdir}/home.mount


  install -d ${D}/mnt/etc/upper
  install -d ${D}/mnt/etc/work
  install -d ${D}/mnt/data/home/work
  install -d ${D}/mnt/data/home/upper
  install -d ${D}/mnt/data/var/lib/
}
FILES_${PN}_append = " /mnt/"
SYSTEMD_SERVICE_${PN} += "etc.mount mnt-etc.mount"
FILES_${PN}_append = " ${systemd_system_unitdir}/"

inherit systemd
