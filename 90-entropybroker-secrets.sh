if [ ! -e $BROKER_USERFILE ];then
    echo "  ${BROKER_USERFILE} not found. Copying defaults..." >&2
    cp /usr/local/entropybroker/etc-dist/users.txt $BROKER_USERFILE
    chmod 600 $BROKER_USERFILE
fi

if [ ! -e $BROKER_CONFIG ];then
    echo "  ${BROKER_CONFIG} not found. Copying defaults..." >&2
    cp /usr/local/entropybroker/etc-dist/entropy_broker.conf $BROKER_CONFIG
    chmod 600 $BROKER_CONFIG

    echo "  Applying ${BROKER_CONFIG} template..."
    sed -i "s|^users = .*|users = ${BROKER_USERFILE}|" $BROKER_CONFIG
fi
