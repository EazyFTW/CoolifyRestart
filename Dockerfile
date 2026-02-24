FROM python:3.11-alpine

# Install supercronic for cron jobs
ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.2.29/supercronic-linux-amd64 \
    SUPERCRONIC=supercronic-linux-amd64

RUN wget "$SUPERCRONIC_URL" && \
    chmod +x "$SUPERCRONIC" && \
    mv "$SUPERCRONIC" /usr/local/bin/supercronic

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY main.py .

# Create the crontab file (3 AM every night)
RUN echo "0 3 * * * python /app/main.py" > crontab

# Run supercronic
CMD ["supercronic", "crontab"]
