#!/bin/bash

# PCF: Portable Crawling Framework

source setenv.sh

printf "\n\n###### Starting Zookeeper Service...\n"
${PCF_KAFKA_HOME}/bin/zookeeper-server-start.sh ${PCF_KAFKA_HOME}/config/zookeeper.properties &
sleep 5
printf "\n\n###### Done\n"
printf "\n\n###### Starting Kafka Sercice...\n"
${PCF_KAFKA_HOME}/bin/kafka-server-start.sh ${PCF_KAFKA_HOME}/config/server.properties &
sleep 8
printf "\n\n###### Done\n"

#printf "\n\n###### Creating Kafka Topics...\n"
#${PCF_KAFKA_HOME}/bin/kafka-topics.sh --create --zookeeper ${PCF_KAFKA_HOST}:2181 --replication-factor 1 --partitions 1 --topic notify
#${PCF_KAFKA_HOME}/bin/kafka-topics.sh --create --zookeeper ${PCF_KAFKA_HOST}:2181 --replication-factor 1 --partitions 1 --topic copy-segments
#printf "\n\n###### Done\n"

#printf "\n\n###### Following Kafka Topics are created:\n"
#${PCF_KAFKA_HOME}/bin/kafka-topics.sh --list --zookeeper ${PCF_KAFKA_HOST}:2181

printf "\n\n###### Starting Kafka Consumer Service...\n"
${PCF_KAFKA_HOME}/bin/kafka-pcf.sh ${PCF_KAFKA_HOME}/config/pcf.properties ${PCF_KAFKA_HOST}:2181 &
sleep 5
printf "\n\n###### Done\n"
