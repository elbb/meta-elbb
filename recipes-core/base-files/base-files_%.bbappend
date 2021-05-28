FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
  file://etc.mount \
  file://home.mount \
  file://mnt-data.mount \
  file://mnt-etc.mount \
  file://var-lib.mount \
  "

do_install_append() {
  install -d ${D}${systemd_system_unitdir}
  install -m 0644 ${WORKDIR}/etc.mount ${D}${systemd_system_unitdir}/
  install -m 0644 ${WORKDIR}/home.mount ${D}${systemd_system_unitdir}/
  install -m 0644 ${WORKDIR}/mnt-data.mount ${D}${systemd_system_unitdir}/
  install -m 0644 ${WORKDIR}/mnt-etc.mount ${D}${systemd_system_unitdir}/
  install -m 0644 ${WORKDIR}/var-lib.mount ${D}${systemd_system_unitdir}/

  install -d ${D}/mnt/etc/upper
  install -d ${D}/mnt/etc/work
  install -d ${D}/mnt/data/home/work
  install -d ${D}/mnt/data/home/upper
  install -d ${D}/mnt/data/var/lib/
}
FILES_${PN}_append = " /mnt/"
SYSTEMD_SERVICE_${PN} += " \
  etc.mount \
  home.mount \
  mnt-data.mount \
  mnt-etc.mount \
  var-lib.mount \
  "
FILES_${PN}_append = " ${systemd_system_unitdir}/"

inherit systemd
