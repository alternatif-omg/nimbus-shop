#!/bin/bash
ENV_FILE="../../backend/.env"
OUT_FILE="secrets.yaml"

encode() {
  grep "^$1=" "$ENV_FILE" | cut -d '=' -f2- | tr -d '\r' | base64 -w 0
}

cat > "$OUT_FILE" << YAML
apiVersion: v1
kind: Secret
metadata:
  name: backend-secrets
  namespace: ecommerce
type: Opaque
data:
  MONGO_URI: $(encode MONGO_URI)
  UPSTASH_REDIS_URL: $(encode UPSTASH_REDIS_URL)
  ACCESS_TOKEN_SECRET: $(encode ACCESS_TOKEN_SECRET)
  REFRESH_TOKEN_SECRET: $(encode REFRESH_TOKEN_SECRET)
  CLOUDINARY_CLOUD_NAME: $(encode CLOUDINARY_CLOUD_NAME)
  CLOUDINARY_API_KEY: $(encode CLOUDINARY_API_KEY)
  CLOUDINARY_API_SECRET: $(encode CLOUDINARY_API_SECRET)
  STRIPE_SECRET_KEY: $(encode STRIPE_SECRET_KEY)
YAML

echo "secrets.yaml generated successfully."
