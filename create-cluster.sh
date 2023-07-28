#!/bin/sh
export PATH=$PATH:/zato/code/bin/
zato create odb --odb-type postgresql --odb-host db --odb-port 5432 --odb-user postgres --odb-db-name zato --odb-password $POSTGRES_PASSWORD
zato create cluster prod1 --odb-type postgresql --odb-host db --odb-port 5432 --odb-user postgres --odb-db-name zato --odb-password $POSTGRES_PASSWORD --lb-host lb
zato create web-admin /env/prod1/web-admin --odb-type postgresql --odb-host db --odb-port 5432 --odb-user postgres --odb-db-name zato --odb-password $POSTGRES_PASSWORD
zato create load-balancer /env/prod1/load-balancer