# Use Python image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy application
COPY app.py .

# Expose the port Flask uses
EXPOSE 8080

# Command to run the app
CMD ["python", "app.py"]
