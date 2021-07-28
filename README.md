# Kafka-CLI-Tools Docker

> ### Note
> This is based on https://gitlab.com/ricardomendes/docker-ssh-aws-fargate. Credits to Ricardo for base image enabling ssh. More on [here](https://medium.com/ci-t/9-steps-to-ssh-into-an-aws-fargate-managed-container-46c1d5f834e2)


A Docker image that allows connecting to an [__AWS Fargate__][1] managed
container through SSH and use kafka management tools such as kafkacat, ksql cli, kcctl..etc. User authentication is done by a public and private key
pair; containers receive the public key as an environment variable.

You need to define the following env variables

`SSH_PUBLIC_KEY` : public key of host machine to connect to this image

`KAFKA_BROKER`   : List of Kafka brokers,seperated by comma

`KSQL_SERVER`    : KSQL server address (Eg. http://ksql-server:8088)

`CONNECT_SERVER` : Kafka Connect server address (Eg. http://<connect server>:8083)

`SCHEMA_REGISTRY`: Confluent Schema Registry address (Eg. http://<schema-registry-address:8081)


## Usage 
First build the image or pull from dockerhub

```
docker build --rm -t kafka-cli-tools .
```

or pull from dockerhub
```
docker pull oneryalcin/kafka-cli-tools
```

Run the docker and set environment variables 

```
docker run --env "SSH_PUBLIC_KEY=<YOUR_PUBLIC_KEY>" \
           --env KSQL_SERVER="http://<KSQL_SERVER_ADDRESS>:8088" \
           --env CONNECT_SERVER="http://localhost:8083" \
           --env SCHEMA_REGISTRY="foo" \
           --env KAFKA_BROKER=bar \
           kafka-cli-tools:0.0.1
```

You should be able to ssh into the image (not using exec command) 

```
ssh root@<container_ip> 
```
