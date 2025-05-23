#!/bin/sh
set -e

# Execute initialization scripts if database doesn't exist
if [ ! -d "/var/lib/mysql/mysql" ]; then
    for f in /docker-entrypoint-initdb.d/*; do
        case "$f" in
            *.sh)  echo "$0: running $f"; . "$f" ;;
            *.sql) echo "$0: running $f"; mysql < "$f"; echo ;;
            *)     echo "$0: ignoring $f" ;;
        esac
        echo
    done
fi

# Start MariaDB
exec "$@"
