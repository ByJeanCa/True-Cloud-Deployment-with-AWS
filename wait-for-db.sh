#!/bin/bash

set -e

ENV=${ENV:-prod}

count=1
max_attempts=10

if [ "$ENV" == "test" ]; then
    echo "Environment: TEST. Waiting for db-test:5432..."
    until nc -z db-test 5432; do
        echo "Attempt #$count: Waiting for db-test on port 5432..."
        count=$((count + 1))
        if [ "$count" -ge "$max_attempts" ]; then
            echo "❌ Maximum number of attempts reached ($max_attempts). Leaving..."
            exit 1
        fi      
        sleep 2
    done
else
    echo "Environment: PROD. Waiting for db:5432..."
    until nc -z db 5432; do
        echo "Attempt #$count: Waiting for db on port 5432..."
        count=$((count + 1))
        if [ "$count" -ge "$max_attempts" ]; then
            echo "❌ Maximum number of attempts reached ($max_attempts). Leaving..."
            exit 1
        fi
        sleep 2
    done
fi

echo "✅ Database is ready. Continuing..."
exec "$@"
