#!/bin/sh

# Start gpsd
gpsd $GPSD_OPTIONS

# Run the main application
python3 gpsd_influx2.py