#!/bin/sh

# Start GPSD using the environment variable options
gpsd $GPSD_OPTIONS

# Run the Python script
python gpsd_influx2.py -s