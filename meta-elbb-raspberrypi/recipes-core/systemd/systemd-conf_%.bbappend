do_install_append() {
    #workaround for https://github.com/kubernetes/minikube/issues/6655 https://github.com/systemd/systemd/issues/8686
    sed -i -E "s/^DHCP=(.+)/DHCP=yes\nLinkLocalAddressing=no/" ${D}/lib/systemd/network/80-wired.network
}
