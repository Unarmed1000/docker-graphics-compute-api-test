#!/bin/bash

# Use the passed in HOST_UID and HOST_GID or a fallback

DEV_UID=${HOST_UID:-9001}
DEV_GID=${HOST_GID:-9001}
DEV_USER_GROUP=$DEV_UID:$DEV_GID

echo "Starting with USER: $USER UID: $DEV_UID GID: $DEV_GID"

# If DEV_USER_GROUP environment variable set to something other than 0:0 (root:root),
# become user:group set within and exec command passed in args
if [ "$DEV_USER_GROUP" != "0:0" ]; then
    # Updated the baked 'dev' user then execute the desired command as the dev user
    usermod -u $DEV_UID $USER
    groupmod -g $DEV_GID $USER

    exec gosu $DEV_USER_GROUP "$@"
else
    # If DEV_USER_GROUP was 0:0 exec command passed in args without su-exec (assume already root)
    exec "$@"
fi
