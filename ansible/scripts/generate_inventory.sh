#!/bin/bash
set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

cd "$PROJECT_ROOT/vagrant"

vagrant ssh-config > "$PROJECT_ROOT/ansible/inventory/vagrant_ssh_config"

echo "Inventory generated."
