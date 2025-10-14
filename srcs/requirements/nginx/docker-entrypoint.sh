#!/bin/bash
set -e

# Default values
CERT_DIR="/etc/ssl"
PRIVATE_KEY_PATH="${CERT_DIR}/private/nginx-selfsigned.key"
CERT_PATH="${CERT_DIR}/certs/nginx-selfsigned.crt"
DOMAIN="${DOMAIN:-localhost}" # Default domain if not set
CERT_DAYS="${CERT_DAYS:-365}" # Default validity period if not set

# Create necessary directories if missing
mkdir -p "${CERT_DIR}/private" "${CERT_DIR}/certs"

# Generate self-signed certificate only if it doesn't already exist
if [ ! -f "${PRIVATE_KEY_PATH}" ] || [ ! -f "${CERT_PATH}" ]; then
  echo "🔐 Generating new self-signed certificate for domain: ${DOMAIN}"
  openssl req -x509 -nodes -newkey rsa:2048 \
      -keyout "${PRIVATE_KEY_PATH}" \
      -out "${CERT_PATH}" \
      -days "${CERT_DAYS}" \
      -subj "/C=MY/ST=Selangor/L=KualaLumpur/O=MyOrg/OU=IT/CN=${DOMAIN}"
  chmod 600 "${PRIVATE_KEY_PATH}"
  echo "✅ Certificate generated at:"
  echo "   - ${CERT_PATH}"
  echo "   - ${PRIVATE_KEY_PATH}"
else
  echo "ℹ️ Existing certificate found. Skipping generation."
fi

# Optional: generate a strong DH param file for SSL security (once)
# DHPARAM_PATH="${CERT_DIR}/certs/dhparam.pem"
# if [ ! -f "${DHPARAM_PATH}" ]; then
#   echo "⚙️  Generating DH parameters (may take a minute)..."
#   openssl dhparam -out "${DHPARAM_PATH}" 2048
#   echo "✅ DH parameters created at ${DHPARAM_PATH}"
# fi

# Start NGINX (or any command passed to the container)
echo "🚀 Starting NGINX..."
exec "$@"
