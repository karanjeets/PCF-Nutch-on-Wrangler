# PCF - Nutch on Wrangler

A Portable Crawling Framework (PCF) for [Apache Nutch 1.x](http://nutch.apache.org/) to run on [TACC Wrangler](https://www.tacc.utexas.edu/systems/wrangler) - a supercomputer funded by NSF.

This was started as a part of another project - "Crawl Evaluation" where we evaluated Apache Nutch v1.12 on Wrangler in both Hadoop and Local mode thereby pushing the crawler to its limits for a best throughput. It also includes some of the challenging stuff - Broad crawling, Focused crawling, Intelligent Crawling, Domain Discovery and many more...

PCF provides a crawling workspace for Wrangler which is both automated and portable. It is now integrated with Apache Kafka as well. More details can be found from the respective README files.

#### Quick Links

* [Seeds](workspace/seeds/)
* [Wrangler Jobs](workspace/jobs/)
* [Crawling](workspace/crawling/)
* [Kafka](workspace/kafka/)
* [Logs](workspace/logs/)
* [Nutch-Config](workspace/nutch-config/)
* [Scripts](workspace/scripts/)
* [Stats](workspace/stats/)
* [Dumping](workspace/dumping/)
