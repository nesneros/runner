#! /bin/sh

echo "Date/time: $(date)"
echo "Execute: $@"
exec "$@"