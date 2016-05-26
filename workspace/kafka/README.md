# Apache Kafka

This space is reserved for Apache Kafka. We have written our custom Consumer [PcfMultiThreadConsumer](../../kafka/src/main/java/kafka/examples/PcfMultiThreadConsumer.java) which listens to every topic configured in [config/pcf.properties](config/pcf.properties) and executes a task (as Bash script) on receiving a message.

To use this, **PCF_KAFKA** should be set to "ON" in [setenv.sh](../setenv.sh)