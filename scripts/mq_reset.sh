#!/usr/bin/env bash
set -euo pipefail

docker compose -f config/docker-compose.yml down -v
