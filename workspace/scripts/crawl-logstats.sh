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

# Author: Karanjeet Singh (USC)
# Script to extract crawl stats from logs

RESULT="FILE,ROUND,GENERATOR,FETCHER,CRAWLDB,LINKDB,DEDUPLICATION";
TMP_FILE=".cstats.temp"
TMP_LOG_FILE=".cstats.log"
LOGS=$1
MODE=$2

display_usage() { 
	echo -e "\nUsage:\n$0 <file containing the path to log files; one log file per line> <Mode - local or hadoop> \n" 
	echo -e "\nUsage:\n$0 --log <log file> <Mode - local or hadoop> \n"
} 

if [[ ( $1 == "--help") ||  $1 == "-h" ]] 
then 
	display_usage
	exit 0
elif [[ ( $1 == "--log") ]]
then
	echo $2 > $TMP_LOG_FILE
	LOGS=$TMP_LOG_FILE
	MODE=$3
fi

if [[ ($MODE != "local" && $MODE != "hadoop") ]]; then echo "Wrong arguments supplied!"; display_usage; exit 1; fi;

if [ ! -f $LOGS ]; then echo "File $LOGS doesn't exist!"; display_usage; exit 1; fi;

while read NLOG
do
	if [ $MODE == "hadoop" ]
	then
		grep -e finished -e Iteration $NLOG | awk -F ": " '{print $2, $3, $4}' | gawk -F " [a-z0-9 :,-]* elapsed" '{print $1, $2}' > ${TMP_FILE};
	else
		grep -e "finished at" -e Iteration $NLOG | awk -F ": " '{print $1, $2, $3, $4}' | gawk -F " [a-z0-9 :,-]* elapsed" '{print $1, $2}' > ${TMP_FILE};
	fi;
	i=1;
	while read x
        do
                if [ `echo $x | grep -q "^Injector"; echo $? == 0` ]; then continue;
                elif [ `echo $x | grep -q "Iteration"; echo $? == 0` ]; then RESULT=${RESULT}\\n${NLOG},${i}; i=`expr ${i} + 1`;
                else RESULT=${RESULT},`echo ${x} | awk '{print $2}'`; fi;
        done < ${TMP_FILE}
done < ${LOGS}

if [ -f $TMP_FILE ]; then rm -f ${TMP_FILE}; fi;
if [ -f $TMP_LOG_FILE ]; then rm -f ${TMP_LOG_FILE}; fi;

echo -e $RESULT

exit 0;
