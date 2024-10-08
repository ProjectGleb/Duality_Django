# Use the official Python image from the Docker Hub
FROM python:3.12.5

# Set the working directory
WORKDIR /app

# Copy the requirements file first to leverage Docker's cache
COPY requirements.txt /app/

# Install system packages and Python dependencies
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libportaudio2 \
    portaudio19-dev \
    libsndfile1 \
    xvfb \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir -r requirements.txt \
    && pip install playwright \
    && playwright install chromium

# Set up Xvfb
ENV DISPLAY=:99

# Copy the rest of the application code
COPY . /app

# Expose the port on which the app will run
EXPOSE 8000

# Use xvfb-run to start the server
CMD ["sh", "-c", "Xvfb :99 -screen 0 1024x768x16 & python manage.py runserver 0.0.0.0:8000"]

# ----- RUNNING DOCKER ON PORT 8000 -----
# docker run -d -p 8000:8000 --env-file .env --name duality_app duality:latest