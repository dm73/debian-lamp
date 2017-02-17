#!/bin/bash
set -e

# PHP
XDEBUG_INI=/etc/php/7.0/fpm/conf.d/20-xdebug.ini
if [[ $ENABLE_XDEBUG ]]; then
    echo "zend_extension=$(find /usr/lib/php/ -name xdebug.so)" > $XDEBUG_INI
else
    [[ -f $XDEBUG_INI ]] && rm -f $XDEBUG_INI
fi

exec "$@"
