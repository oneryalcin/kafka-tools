#!/bin/sh

if [ -z "$SSH_PUBLIC_KEY" ]; then
  echo "Need your SSH public key as the SSH_PUBLIC_KEY env variable."
  exit 1
fi

if [ -z "$KSQL_SERVER" ]; then
  echo "Need your KSQL server address as KSQL_SERVER env variable. Eg: http://<ksqlDB Server address>:8088"
  exit 1
fi

if [ -z "$CONNECT_SERVER" ]; then
  echo "Need your Connect server address as CONNECT_SERVER env variable. Eg: http://<connect server>:8083"
  exit 1
fi

if [ -z "$SCHEMA_REGISTRY" ]; then
  echo "Need your Schema Registy address as SCHEMA_REGISTRY env variable. Eg: http://<schema-registry-address>:8081"
  exit 1
fi

if [ -z "$KAFKA_BROKER" ]; then
  echo "Need your Kafka Brokers as KAFKA_BROKER. Eg: kafka-broker:9092"
  exit 1
fi

# kcctl is not fully stable yet so we need to carefully set few things
touch ~/.kcctl
chmod 777 ~/.kcctl
mkdir -p /home/runner
touch /home/runner/.kcctl
chmod 777 ~/home/runner/.kcctl

kcctl config set-context --cluster=$CONNECT_SERVER


# Create a folder to store user's SSH keys if it does not exist.
USER_SSH_KEYS_FOLDER=~/.ssh
[ ! -d "$USER_SSH_KEYS_FOLDER" ] && mkdir -p $USER_SSH_KEYS_FOLDER

# Copy contents from the `SSH_PUBLIC_KEY` environment variable
# to the `${USER_SSH_KEYS_FOLDER}/authorized_keys` file.
# The environment variable must be set when the container starts.
echo $SSH_PUBLIC_KEY > ${USER_SSH_KEYS_FOLDER}/authorized_keys

# Add alias to KSQL server connectivity
echo alias ksql-cli=\"ksql "$KSQL_SERVER"\" >> ~/.bashrc

# Add all env Variables
echo export KSQL_SERVER="$KSQL_SERVER" >> ~/.bashrc
echo export CONNECT_SERVER="$CONNECT_SERVER" >> ~/.bashrc
echo export SCHEMA_REGISTRY="$SCHEMA_REGISTRY" >> ~/.bashrc
echo export KAFKA_BROKER="$KAFKA_BROKER" >> ~/.bashrc

# Clear the `SSH_PUBLIC_KEY` environment variable.
unset SSH_PUBLIC_KEY

# Start the SSH daemon.
/usr/sbin/sshd -D
