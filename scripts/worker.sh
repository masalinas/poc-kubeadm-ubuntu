#!/bin/bash
# =============================================================================
# scripts/worker.sh: Incorporación automatizada del nodo worker (k8s-worker1)
# =============================================================================
set -euo pipefail

echo "==> [WORKER] 1. Esperando a que el nodo Master genere el token de unión..."
MAX_WAIT=300
ELAPSED=0

while [ ! -f /vagrant_configs/join.sh ]; do
  sleep 3
  ELAPSED=$((ELAPSED + 3))
  if [ "${ELAPSED}" -ge "${MAX_WAIT}" ]; then
    echo "==> [ERROR] Tiempo de espera superado. El script join.sh no fue generado en /vagrant_configs."
    exit 1
  fi
done

echo "==> [WORKER] 2. Ejecutando unión automatizada al cluster..."
bash /vagrant_configs/join.sh > /dev/null

echo "==> [WORKER] ¡Nodo k8s-worker1 incorporado exitosamente al cluster!"
