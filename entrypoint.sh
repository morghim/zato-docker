#!/bin/sh
export PATH=$PATH:/zato/code/bin/
DIR=/env/prod1
# make quieck start on zato with db host
if [ -d "$DIR" ]
then
    echo "start another container"
    ./env/prod1/zato-qs-start.sh
else
    echo "initial zato first run"
    zato quickstart create --odb-type postgresql --odb-host db --odb-port 5432 --odb-user postgres --odb-db-name zato --odb-password $POSTGRES_PASSWORD --verbose /env/prod1
    zato update password /env/prod1/web-admin/ admin --password $ADMIN_PASSWORD
    ./env/prod1/zato-qs-start.sh
    sleep 5

fi

tail -f /dev/null

 
