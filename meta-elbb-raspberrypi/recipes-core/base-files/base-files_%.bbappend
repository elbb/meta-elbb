FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " file://fstab.raspberrypi"

do_install_append_rpi() {
  install -m 0644 ${WORKDIR}/fstab.raspberrypi ${D}/etc/fstab

  # install -d ${D}/mnt
  # install -d ${D}/mnt/etc
  install -d ${D}/mnt/etc/.etc-work
  # install -d ${D}/mnt/data
  install -d ${D}/mnt/data/.home-work
  install -d ${D}/mnt/data/home
}

FILES_${PN}_append = " /mnt/"