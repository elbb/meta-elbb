# Since we don't know the DISTRO_FEATURES during layer.conf load time, we
# delay using this special bbclass that simply includes the TPM_CONFIG_PATH file.

require ${TPM_CONFIG_PATH}
