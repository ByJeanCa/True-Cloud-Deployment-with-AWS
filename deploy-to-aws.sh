#!/bin/bash

set -e

# Variables
AWS_REGION="us-east-1"
ECR_REGISTRY="140516499605.dkr.ecr.us-east-1.amazonaws.com"
REPO_NAME="flask-api"
IMAGE_TAG="latest"
APP_NAME="flask-api"
ENV_NAME="FlaskApi-env"
ZIP_NAME="flask-api-v4.zip"

echo "Iniciando sesión en Amazon ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REGISTRY

echo "Construyendo la imagen Docker..."
docker build -t $REPO_NAME .
docker tag $REPO_NAME:$IMAGE_TAG $ECR_REGISTRY/$REPO_NAME:$IMAGE_TAG

echo "Subiendo la imagen a ECR..."
docker push $ECR_REGISTRY/$REPO_NAME:$IMAGE_TAG

echo "Creando archivo ZIP para Beanstalk..."
zip -r $ZIP_NAME Dockerrun.aws.json > /dev/null

echo "Subiendo nueva versión de aplicación a Elastic Beanstalk..."
aws elasticbeanstalk create-application-version \
  --application-name $APP_NAME \
  --version-label $IMAGE_TAG \
  --source-bundle S3Bucket=YOUR_BUCKET_NAME,S3Key=$ZIP_NAME \
  --region $AWS_REGION

echo "Desplegando en Elastic Beanstalk..."
aws elasticbeanstalk update-environment \
  --region $AWS_REGION \
  --application-name $APP_NAME \
  --environment-name $ENV_NAME \
  --version-label $IMAGE_TAG
