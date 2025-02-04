FROM resin/rpi-raspbian:jessie
MAINTAINER Gary Ritchie <gary@garyritchie.com>

# Install openvpn
RUN export DEBIAN_FRONTEND='noninteractive' && \
    apt-get update -qq && \
    apt-get install -qqy --no-install-recommends iptables openvpn procps \
                $(apt-get -s dist-upgrade|awk '/^Inst.*ecurity/ {print $2}') &&\
    echo '#!/usr/bin/env bash' >/sbin/resolvconf && \
    echo 'conf=/etc/resolv.conf' >>/sbin/resolvconf && \
    echo '[[ -e $conf.orig ]] || cp -p $conf $conf.orig' >>/sbin/resolvconf && \
    echo 'if [[ "${1:-""}" == "-a" ]]; then' >>/sbin/resolvconf && \
    echo '    cat >${conf}' >>/sbin/resolvconf && \
    echo 'elif [[ "${1:-""}" == "-d" ]]; then' >>/sbin/resolvconf && \
    echo '    cat $conf.orig >$conf' >>/sbin/resolvconf && \
    echo 'fi' >>/sbin/resolvconf && \
    chmod +x /sbin/resolvconf && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* && \
    addgroup --system vpn
COPY openvpn.sh /usr/bin/

VOLUME ["/vpn"]

ENTRYPOINT ["openvpn.sh"]
