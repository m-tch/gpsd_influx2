# Use an official Python runtime as a parent image
FROM python:3.9-alpine

# Install gpsd and git
RUN apk add --no-cache gpsd git

# Set the working directory
WORKDIR /app/gpsd_influx2

# Copy the requirements file and install Python dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Ensure the entrypoint script has executable permissions
RUN chmod +x /app/gpsd_influx2/entrypoint.sh

# Expose GPSD port
EXPOSE 2947

# Setup environment variables if needed
ENV GPSD_OPTIONS="-n -N -b /dev/your-gps-device"
ENV INFLUXDB_V2_URL="http://influxdb:8086"
ENV INFLUXDB_V2_ORG="my-site"
ENV INFLUXDB_V2_TOKEN="my-token"
ENV INFLUXDB_V2_BUCKET="gpsd"

# Add a simple healthcheck
HEALTHCHECK --interval=30s --timeout=10s \
  CMD pgrep gpsd || exit 1

# CMD using the script
CMD ["/app/gpsd_influx2/entrypoint.sh"]