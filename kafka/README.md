# Kafka - PCF Consumer

This space is reserved for the development of Apache Kafka consumer. We have written our custom Consumer [PcfMultiThreadConsumer](src/main/java/kafka/examples/PcfMultiThreadConsumer.java) which listens to every topic configured in [pcf.properties](src/main/java/kafka/examples/pcf.properties) and executes a task (as Bash script) on receiving a message.