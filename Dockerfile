FROM python:3.10-bullseye

WORKDIR /aws-api

RUN apt-get update && apt-get install -y --no-install-recommends --fix-missing gcc netcat-openbsd 

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN chmod +x wait-for-db.sh

ENTRYPOINT ["./wait-for-db.sh"]
CMD ["python", "app.py"]