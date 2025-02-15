# Use Python 3.12 slim version as base image
FROM python:3.12-slim-bookworm

# Install system dependencies required for SciPy and other libraries
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gfortran libatlas-base-dev curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install uv
ADD https://astral.sh/uv/install.sh /uv-installer.sh
RUN sh /uv-installer.sh && rm /uv-installer.sh

# Install required Python packages
RUN pip install --no-cache-dir fastapi uvicorn python-dateutil requests scipy \
    python-dotenv httpx pandas db-sqlite3 pybase64 markdown duckdb 

# Ensure the installed binary is on the `PATH`
ENV PATH="/root/.local/bin:$PATH"

# Set up the application directory
WORKDIR /app

# Copy all application files
COPY . /app

# Expose port
EXPOSE 8000

# Start the FastAPI server
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
