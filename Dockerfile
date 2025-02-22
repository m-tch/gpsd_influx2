# Use an official Python runtime as a parent image
FROM python:3.9-alpine

# Install gpsd and git
RUN apt-get update && \
    apt-get install -y gpsd git && \
    rm -rf /var/lib/apt/lists/*

# Clone the gpsd_influx2 repository
RUN git clone https://github.com/longview/gpsd_influx2.git /app/gpsd_influx2

# Set the working directory
WORKDIR /app/gpsd_influx2

# Install Python dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Expose GPSD port
EXPOSE 2947

# Setup environment variables if needed
ENV GPSD_OPTIONS="-n -N -b /dev/your-gps-device"
ENV INFLUXDB_V2_URL="http://influxdb:8086"
ENV INFLUXDB_V2_ORG = "my-site"
ENV INFLUXDB_V2_TOKEN = "my-token"
ENV INFLUXDB_V2_BUCKET = "gpsd"

# Add a simple healthcheck
HEALTHCHECK --interval=30s --timeout=10s \
  CMD pgrep gpsd || exit 1

# Copy Entry Script to Image
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# CMD using the script
CMD ["/app/entrypoint.sh"]