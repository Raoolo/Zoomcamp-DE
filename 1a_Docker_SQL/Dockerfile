# Use the official Python 3.9.1 image from the Docker Hub as the base image
FROM python:3.9.1

# Update the package list and install wget
RUN apt-get update && apt-get install wget

# Upgrade pip to the latest version
RUN pip install --upgrade pip

# Install necessary Python packages: pandas, sqlalchemy, psycopg2, and pyarrow
RUN pip install pandas sqlalchemy psycopg2 pyarrow

# Set the working directory to /app
WORKDIR /app

# Copy the ingest_data.py script from the local machine to the container's /app directory
COPY ingest_data.py ingest_data.py

# Set the entry point to run the ingest_data.py script using Python interpreter
ENTRYPOINT [ "python", "ingest_data.py" ]
