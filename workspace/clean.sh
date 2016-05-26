#!/bin/bash

# PCF: Portable Crawling Framework

source setenv.sh

if [ `ps ax | grep -v grep | grep -iq 'PcfMultiThreadConsumer'; echo $? == 0` ]; then
	printf "\n\n###### Stopping Kafka Consumer Service...\n"
	for topic in `grep ^topics ${PCF_KAFKA_HOME}/config/pcf.properties | cut -d"=" -f2 | sed  "s/\.[0-9]*//g" | sed "s/,/ /g"`
	do
		echo "Sending STOP signal to Kafka Topic: $topic"
        	echo "STOP-KAFKA" | ${PCF_KAFKA_HOME}/bin/kafka-console-producer.sh --broker-list ${PCF_KAFKA_HOST}:9092 --topic ${topic}
	done
	sleep 5
	printf "\n\n###### Done\n"
fi

printf "\n\n###### Stopping Kafka Service...\n"
${PCF_KAFKA_HOME}/bin/kafka-server-stop.sh
sleep 8
printf "\n\n###### Done\n"
printf "\n\n###### Stopping Zookeeper Service...\n"
${PCF_KAFKA_HOME}/bin/zookeeper-server-stop.sh
sleep 5
printf "\n\n###### Done\n"
