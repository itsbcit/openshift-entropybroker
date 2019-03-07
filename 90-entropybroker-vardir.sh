if [ ! -d /usr/local/entropybroker/var/cache ];then
    mkdir -p /usr/local/entropybroker/var/cache
    chmod 0700 /usr/local/entropybroker/var/cache
fi

if [ ! -d /usr/local/entropybroker/var/run ];then
    mkdir -p /usr/local/entropybroker/var/run
    chmod 0700 /usr/local/entropybroker/var/run
fi
