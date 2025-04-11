#!/bin/bash
set -e

# Variables
AWS_REGION="us-east-1"
ECR_REGISTRY="tu-id-de-cuenta.dkr.ecr.us-east-1.amazonaws.com"
REPO_NAME="flask-api"
IMAGE_TAG="latest"

# Iniciar sesión en ECR
echo "Iniciando sesión en Amazon ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REGISTRY

# Construir y etiquetar la imagen Docker
echo "Construyendo la imagen Docker..."
docker build -t $REPO_NAME .
docker tag $REPO_NAME:$IMAGE_TAG $ECR_REGISTRY/$REPO_NAME:$IMAGE_TAG

# Subir la imagen a ECR
echo "Subiendo la imagen a ECR..."
docker push $ECR_REGISTRY/$REPO_NAME:$IMAGE_TAG

# Desplegar en Elastic Beanstalk
echo "Desplegando en Elastic Beanstalk..."
aws elasticbeanstalk update-environment \
    --region $AWS_REGION \
    --application-name flask-api \
    --environment-name FlaskApi-env \
    --version-label $IMAGE_TAG
