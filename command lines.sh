export CLOUDSDK_PYTHON="C:/Users/Admin/AppData/Local/Programs/Python/Python312/python"

export GOOGLE_APPLICATION_CREDENTIALS="W:/google_credentials.json"

gcloud auth activate-service-account --key-file $GOOGLE_APPLICATION_CREDENTIALS

int3507-5-assignment

### Create ssh key
ssh-keygen -t rsa -f ~/.ssh/gcp -C nguyenduyhung -b 2048

Host streamify-kafka
    HostName 35.193.229.176
    User nguyenduyhung
    IdentityFile c:/Users/Admin/.ssh/gcp

Host streamify-spark
    HostName 35.193.229.176
    User nguyenduyhung
    IdentityFile c:/Users/Admin/.ssh/gcp

Host streamify-airflow
    HostName 34.28.199.106
    User nguyenduyhung
    IdentityFile c:/Users/Admin/.ssh/gcp

 ----------------------------------------------------------------

### Setup Kafka VM

## Establish SSH connection
ssh streamify-kafka

## Clone git repo
git clone https://github.com/duyhuwng2910/streamify.git && \
bash ~/streamify/scripts/vm_setup.sh && \
exec newgrp docker

## Set the environment variable
export KAFKA_ADDRESS=35.193.229.176

## Start Kafka
cd ~/streamify/kafka && \
docker-compose build && \
docker-compose up 

## Open another terminal session for the Kafka VM and start sending messages to your Kafka broker with Eventsim
bash ~/streamify/scripts/eventsim_startup.sh

## Follow the logs
docker logs --follow million_events

 ----------------------------------------------------------------

### Setup Spark Cluster

## Establish SSH connection to the master node
ssh streamify-spark

## Clone git repo
git clone https://github.com/duyhuwng2910/streamify.git && \
cd streamify/spark_streaming

## Set the environment variables
export KAFKA_ADDRESS=35.193.229.176
export GCP_GCS_BUCKET=int3507-5

## Start reading messages
spark-submit \
--packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.1.2 \
stream_all_events.py

 ----------------------------------------------------------------

### Setup Airflow VM

## Establish SSH connection
ssh streamify-airflow

## Clone git repo
git clone https://github.com/duyhuwng2910/streamify.git && \
cd streamify

## Install anaconda, docker & docker-compose
bash ~/streamify/scripts/vm_setup.sh && \
exec newgrp docker

## Set the environment variables
export GCP_PROJECT_ID=int3507-5
export GCP_GCS_BUCKET=int3507-5

## Start Airflow
bash ~/streamify/scripts/airflow_startup.sh && cd ~/streamify/airflow

## Follow the logs
docker-compose logs --follow

## Stop Airflow
docker-compose down