# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] unreleased

- tpm configuration and packages are only added when DISTRO_FEATURES includes 'tpm'
- add tpm udev rules (tpm-udev.bb)
- use IMAGE_ROOTFS_MAXSIZE as input size for partition layout
- fail if rootfs exceeds IMAGE_ROOTFS_MAXSIZE (in kb)
- added elbb (update)image wich uses A/B partition layout
- added meta-elbb-raspberrypi layer which configures raspberrypi builds
- added raspberrypi partition layout which supports A/B updates
- raspberrypi rootfs is readonly
- added tpm devicetree + bootconfig for raspberrypi

## [0.1.0] Q4 2020

Initial Version

- add GITVERSION_BRANCHVERSION field in yocto /etc/os_release
- license informations (MIT and Apache V 2.0)
- changelog template
