if [ ! -e $SERVER_USERFILE ];then
    if [ "$SERVER_USERNAME" != "none" ] && [ "$SERVER_PASSWORD" -ne "none";then
        echo "  Populating ${SERVER_USERFILE}..." >&2
        echo "$SERVER_USERNAME" >  $SERVER_USERFILE
        echo "$SERVER_PASSWORD" >> $SERVER_USERFILE
    else
        echo "  ${SERVER_USERFILE} not found. Copying defaults..." >&2
        cp /usr/local/entropybroker/etc-dist/auth.txt $SERVER_USERFILE
        chmod 600 $SERVER_USERFILE
    fi
fi
