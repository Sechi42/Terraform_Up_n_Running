#!/bin/bash
# Script para exportar variables de entorno desde .env

set -a
source .env
set +a

terraform apply

# Uso de raw para evitar comillas dobles
export public_ip=$(terraform output -raw public_ip)

export url="http://$public_ip:$TF_VAR_server_port"

# Esperar 90 segundos antes de hacer el curl
sleep 90

curl "$url"

