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
#SBATCH -J DSSD-SAMPLE          		# Job name
#SBATCH -N 1                   			# Total number of nodes (24 cores/node)
#SBATCH -n 24					# Total number of cores
#SBATCH -p normal          			# Queue name (hadoop or normal or debug)
#SBATCH -o DSSD-SAMPLE.o%j      		# Name of stdout output file (%j expands to jobid)
#SBATCH -t 48:00:00            			# Run time (hh:mm:ss)
#SBATCH -A TG-CIE160008				# Project to run on (write only if you have multiple projects)
#SBATCH --reservation=dssd+TG-CIE160008+1435  	# Reservation Name
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
NUTCH_HOME=${PCF_NUTCH_HOME}/runtime/local; 
RECIPIENTS=""; 
#------------------------------------------------------

sleep 5;
date; 
${NUTCH_HOME}/bin/crawl ${PCF_SEEDS}/${SEED} ${PCF_CRAWLING_LIVE}/crawl-${SEED}-${SLURM_JOBID} 10;
wait;
date;
