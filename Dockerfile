FROM python:3.10-slim

WORKDIR /aws-api

RUN apt-get update $$ apt-get install -y --no-install-recomends \\
    gcc \
    netcat openbsd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["./wait-for-db.sh"]
