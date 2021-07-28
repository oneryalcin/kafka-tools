FROM ubuntu:18.04

# --------------------------------------------------------------------------
# Install and configure sshd.
# https://docs.docker.com/engine/examples/running_ssh_service for reference.
# --------------------------------------------------------------------------
RUN apt-get update \
    && apt-get install -y openssh-server \
    && mkdir -p /var/run/sshd

EXPOSE 22

# --------------------------------------------------------------------------
# Install Java 8 and other tools
# --------------------------------------------------------------------------
RUN apt-get -y install openjdk-8-jre-headless curl unzip jq kafkacat

# --------------------------------------------------------------------------
# Add Confluent CLI Components
# --------------------------------------------------------------------------
RUN curl -O http://packages.confluent.io/archive/6.2/confluent-community-6.2.0.zip \
    && unzip confluent-community-6.2.0.zip \
    && rm -f confluent-community-6.2.0.zip

# --------------------------------------------------------------------------
# Add KCCTL for managing connect
# --------------------------------------------------------------------------
RUN wget https://github.com/kcctl/kcctl/releases/download/1.0.0-early-access/kcctl-1.0.0-early-access-linux-x86_64.zip \
    && unzip kcctl-1.0.0-early-access-linux-x86_64.zip \
    && rm -f kcctl-1.0.0-early-access-linux-x86_64.zip

RUN echo PATH=/kcctl-1.0.0-SNAPSHOT-linux-x86_64/bin:/confluent-6.2.0/bin:$PATH >> /root/.bashrc

# -------------------------------------------------------------------------------------
# Execute a startup script.
# https://success.docker.com/article/use-a-script-to-initialize-stateful-container-data
# for reference.
# -------------------------------------------------------------------------------------
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
