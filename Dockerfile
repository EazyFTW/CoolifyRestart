FROM python:3.11-alpine

# Install tzdata for timezone support and supercronic for cron
RUN apk add --no-cache tzdata && \
    wget https://github.com/aptible/supercronic/releases/download/v0.2.29/supercronic-linux-amd64 && \
    chmod +x supercronic-linux-amd64 && \
    mv supercronic-linux-amd64 /usr/local/bin/supercronic

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY main.py .

# Create the crontab file (runs at 3 AM)
RUN echo "0 3 * * * python /app/main.py" > crontab

# Run supercronic - it will respect the TZ environment variable
CMD ["supercronic", "crontab"]
