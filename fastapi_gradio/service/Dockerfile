# Stage 1: Builder
FROM python:3.11-slim as builder

WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends build-essential

# Copy package list and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade -r requirements.txt

# Copy the whole folder to the container
COPY . .

# Clean up unnecessary files to reduce image size
# RUN apt-get remove -y build-essential && apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/*

# Stage 2: Final
FROM python:3.11-slim

WORKDIR /app

# Add non-root user early and set permissions
RUN adduser --disabled-password --gecos '' appuser && chown -R appuser /app
USER appuser

# Copy the application code and dependencies from the builder stage
COPY --from=builder /app /app
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

EXPOSE 80

# Default command
CMD ["uvicorn", "serve:app", "--host", "0.0.0.0", "--port", "80"]
