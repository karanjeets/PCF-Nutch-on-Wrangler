# Portable Crawling Framework (PCF)

A sample crawling workspace for Wrangler which is both automated and portable. The framework is integrated with Apache Kafka with a custom Consumer which helps to run your tasks (as bash scripts) on any event. 

Clone it and crawl. 

More details can be found from the respective README files.

#### How to Setup ?
* Change the path to **PCF_WORKSPACE** in [setenv.sh](setenv.sh)
* Set **PCF_KAFKA="ON"** in (setenv.sh)[setenv.sh] if you need Apache Kafka
* Configure [kafka/config/pcf.properties](kafka/config/pcf.properties) to set the tasks against a Kafka topic
* Run [setup.sh](setup.sh) to configure the environment and start Kafka services
* Run [clean.sh](clean.sh) to stop Kafka services

#### Quick Links

* [Seeds](seeds/)
* [Wrangler Jobs](jobs/)
* [Crawling](crawling/)
* [Kafka](kafka/)
* [Logs](logs/)
* [Nutch-Config](nutch-config/)
* [Scripts](scripts/)
* [Stats](stats/)
* [Dumping](dumping/)
