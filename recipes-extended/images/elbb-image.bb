FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

DESCRIPTION = "elbb swupdate image"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "\
    file://sw-description \
"

# images to build before building swupdate image
IMAGE_DEPENDS = "core-image-base virtual/kernel"

# images and files that will be included in the .swu image
SWUPDATE_IMAGES = "core-image-base"

SWUPDATE_IMAGES_FSTYPES[core-image-base] = ".ext4.gz"

#sign image
SWUPDATE_SIGNING = "RSA"

inherit swupdate
