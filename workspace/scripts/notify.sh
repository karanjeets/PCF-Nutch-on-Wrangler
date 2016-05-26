#!/bin/bash

# author: Karanjeet Singh
# Send E-mail notifications

RECEPIENTS="karanjes@usc.edu"

echo $1 | mail -s "PCF: Notification" $RECEPIENTS

