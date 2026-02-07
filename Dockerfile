FROM python:3.13-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Set required environment variables for build-time
ENV AUDIO_FILES_PATH=/app/audio

# Add src to Python path
ENV PYTHONPATH=/app/src:$PYTHONPATH

# Copy pyproject.toml first for better Docker layer caching
COPY pyproject.toml ./
COPY README.md ./

# Install the package in development mode
RUN pip install --no-cache-dir -e .

# Copy the rest of the application
COPY . .

# Expose port (if needed for direct HTTP access)
EXPOSE 8001

# Command to run the MCP server
CMD ["mcp-server-whisper"]