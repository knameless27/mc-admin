#!/usr/bin/env bash

set -e

MC_HOME="$(cd "$(dirname "$0")" && pwd)"
cd "$MC_HOME"

ACTION="$1"
SERVICE="$2"
shift 2 || true
COMMAND="$*"

usage() {
  echo "Usage:"
  echo "  mc up [service]"
  echo "  mc down"
  echo "  mc restart <service>"
  echo "  mc logs <service>"
  echo "  mc exec <service> <minecraft command>"
  echo "  mc ps"
  echo "  mc list"
  exit 1
}

case "$ACTION" in
  up)
    if [[ -n "$SERVICE" ]]; then
      docker compose up -d "$SERVICE"
    else
      echo "  Service not found!"
    fi
    ;;
  down)
    docker compose down
    ;;
  restart)
    [[ -z "$SERVICE" ]] && usage
    docker compose restart "$SERVICE"
    ;;
  logs)
    [[ -z "$SERVICE" ]] && usage
    docker compose logs -f "$SERVICE"
    ;;
  exec)
    [[ -z "$SERVICE" || -z "$COMMAND" ]] && usage
    CONTAINER_ID="$(docker compose ps -q "$SERVICE")"
    if [[ -z "$CONTAINER_ID" ]]; then
      echo "❌ Service '$SERVICE' not running."
      exit 1
    fi
    docker exec "$CONTAINER_ID" rcon-cli $COMMAND
    ;;
  ps)
    docker compose ps
    ;;
  list)
    echo "🧩 Services available:"
    docker compose config --services
    ;;
  -h)
    usage
    ;;
  *)
    usage
    ;;
esac
