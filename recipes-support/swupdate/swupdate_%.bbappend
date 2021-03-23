FILESEXTRAPATHS_append := "${THISDIR}/${PN}:"

do_install_append(){
  if [ -z ${HW_REV} ];then exit 1; fi
  if [ -z ${MACHINE} ];then exit 1; fi
  if [ -z ${SOFTWARE_NAME} ];then exit 1; fi
  if [ -z ${SOFTWARE_VERSION} ];then exit 1; fi
  echo "${MACHINE} ${HW_REV}" >> ${D}/${sysconfdir}/hwrevision
  echo "${SOFTWARE_NAME} ${SOFTWARE_VERSION}" >> ${D}/${sysconfdir}/sw-versions
}

FILES_${PN} += " \
    ${sysconfdir}/hwrevision \
    ${sysconfdir}/sw-versions \
    "

PACKAGECONFIG_CONFARGS = ""
