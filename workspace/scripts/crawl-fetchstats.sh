#!/bin/bash

# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Author: Karanjeet Singh
# Script to extract the number of fetched documents

source ../setenv.sh

RESULT="FILE,FETCHED DOCUMENTS";
TMP_CRAWL_FILE=".cstats.tmp"
CRAWLS=$1

display_usage() { 
	echo -e "\nUsage:\n$0 --crawl <crawl directory> \n"
} 

if [[ ( $1 == "--help") ||  $1 == "-h" ]] 
then 
	display_usage
	exit 0
elif [[ ( $1 == "--crawl") ]]
then
	echo $2 > $TMP_CRAWL_FILE
	CRAWLS=$TMP_CRAWL_FILE
fi

if [[ $# != 2 || ($1 != "--crawl") ]]; then echo "Wrong arguments supplied!"; display_usage; exit 1; fi;

if [ ! -f $CRAWLS ]; then echo "File $CRAWLS doesn't exist!"; display_usage; exit 1; fi;

echo $RESULT;

while read NCRAWL
do
	${PCF_NUTCH_HOME}/runtime/local/bin/nutch readseg -list ${NCRAWL}/segments/* -nogenerate -nocontent -noparse -noparsedata -noparsetext | grep -v "NAME" | awk -v var="$NCRAWL" '{print var"/"$1","$5}';
done < ${CRAWLS}

if [ -f $TMP_CRAWL_FILE ]; then rm -f ${TMP_CRAWL_FILE}; fi;

exit 0;

