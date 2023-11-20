#!/bin/bash

# Define log directory
LOG_DIR="./logs"

# Delete logs older than 30 days
find $LOG_DIR -type f -mtime +30 -exec rm {} \;
