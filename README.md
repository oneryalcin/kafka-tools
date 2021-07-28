# Kafka-admin-tools Docker

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

