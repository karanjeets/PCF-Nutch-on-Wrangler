#!/bin/bash

# PCF: Portable Crawling Framework

printf "\n\n###### Setting up Environment Variables...\n"

#export PCF_WORKSPACE="/work/03755/tg830544/wrangler/memex/sample-workspace";
export PCF_WORKSPACE="/Users/karanjeetsingh/git_workspace/crawl-evaluation/workspace";
export PCF_NUTCH_HOME="${PCF_WORKSPACE}/nutch";
export PCF_CRAWLING_LIVE="${PCF_WORKSPACE}/crawling/live";
export PCF_CRAWLING_ARCHIVE="${PCF_WORKSPACE}/crawling/archive";
export PCF_JOBS="${PCF_WORKSPACE}/jobs";
export PCF_SCRIPTS="${PCF_WORKSPACE}/scripts";
export PCF_DUMPING="${PCF_WORKSPACE}/dumping";
export PCF_LOGS="${PCF_WORKSPACE}/logs";
export PCF_SEEDS="${PCF_WORKSPACE}/seeds";
export PCF_KAFKA_HOME="${PCF_WORKSPACE}/kafka";
export PCF_KAFKA_HOST="localhost";
export PCF_KAFKA="OFF";

printf "\n\n###### Done\n"
