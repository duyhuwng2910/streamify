export CLOUDSDK_PYTHON="C:/Users/Admin/AppData/Local/Programs/Python/Python312/python"

export GOOGLE_APPLICATION_CREDENTIALS="W:/google_credentials.json"

gcloud auth activate-service-account --key-file $GOOGLE_APPLICATION_CREDENTIALS

int3507-5-assignment

### Create ssh key
ssh-keygen -t rsa -f ~/.ssh/gcp -C nguyenduyhung -b 2048

Host streamify-kafka
    HostName 35.238.217.203
    User nguyenduyhung
    IdentityFile c:/Users/Admin/.ssh/gcp

Host streamify-spark
    HostName 35.188.55.127
    User nguyenduyhung
    IdentityFile c:/Users/Admin/.ssh/gcp

Host streamify-airflow
    HostName 34.68.251.248
    User nguyenduyhung
    IdentityFile c:/Users/Admin/.ssh/gcp

### Setup Kafka VM
ssh streamify-kafka

export KAFKA_ADDRESS=35.238.217.203

cd ~/streamify/kafka && \
docker-compose build && \
docker-compose up 

# Open another terminal session for the Kafka VM and start sending messages to your Kafka broker with Eventsim
bash ~/streamify/scripts/eventsim_startup.sh

docker logs --follow million_events

### Setup Spark Cluster

ssh streamify-spark

cd streamify/spark_streaming

export KAFKA_ADDRESS=35.238.217.203
export GCP_GCS_BUCKET=int3507-5-assignment

spark-submit \
--packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.1.2 \
stream_all_events.py

### Setup Airflow VM

ssh streamify-airflow

export GCP_PROJECT_ID=int3507-5-assignment
export GCP_GCS_BUCKET=int3507-5-assignment

bash ~/streamify/scripts/airflow_startup.sh && cd ~/streamify/airflow

docker-compose logs --follow

docker-compose down