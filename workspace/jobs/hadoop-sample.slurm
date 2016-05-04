#!/bin/bash
#
# Simple SLURM script for submitting multiple serial
# jobs (e.g. parametric studies) using a script wrapper
# to launch the jobs.
#
# To use, build the launcher executable and your
# serial application(s) and place them in your WORKDIR
# directory.  Then, edit the CONTROL_FILE to specify 
# each executable per process.
#-------------------------------------------------------
#-------------------------------------------------------
# 
#------------------Scheduler Options--------------------
#SBATCH -J HADOOP-SAMPLE          		# Job name
#SBATCH -N 1                   			# Total number of nodes (24 cores/node)
#SBATCH -n 24					# Total number of cores
#SBATCH -p hadoop          			# Queue name (hadoop or normal or debug)
#SBATCH -o HADOOP-SAMPLE.o%j      		# Name of stdout output file (%j expands to jobid)
#SBATCH -t 48:00:00            			# Run time (hh:mm:ss)
#SBATCH -A TG-CIE160008				# Project to run on (write only if you have multiple projects)
#SBATCH --reservation=hadoop+TG-CIE160008+1435  # Reservation Name
#------------------------------------------------------
#
# Usage:
#	#$ -pe <parallel environment> <number of slots> 
#	#$ -l h_rt=hours:minutes:seconds to specify run time limit
# 	#$ -N <job name>
# 	#$ -q <queue name>
# 	#$ -o <job output file>
#	   NOTE: The env variable $JOB_ID contains the job id. 
#
#------------------------------------------------------

# Source Environment Configuration
source ../setenv.sh

#----------------Customize Configuration---------------
SEED="google"; 
NUTCH_HOME=${PCF_NUTCH_HOME}/runtime/deploy; 
RECIPIENTS=""; 
#------------------------------------------------------

sleep 5;
date; 
if [ `hadoop fs -ls ${SEED} > /dev/null 2>&1; echo $? != 0` ]; then hadoop fs -copyFromLocal ${PCF_SEEDS}/${SEED} ${SEED}; fi;
${NUTCH_HOME}/bin/crawl ${SEED} crawl-${SEED}-${SLURM_JOBID} 10;
echo "Copying data from HDFS to Local";
hadoop fs -copyToLocal crawl-${SEED}-${SLURM_JOBID} ${PCF_CRAWLING_LIVE}/crawl-${SEED}-${SLURM_JOBID};
date;
