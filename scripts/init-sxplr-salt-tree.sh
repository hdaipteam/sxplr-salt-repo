#!/usr/bin/env bash
#
# init-sxplr-salt-tree.sh
#
# Erzeugt die Basis-Struktur für das Salt-Repository
# gemäß den file_roots:
#   base: /srv/salt
#   dev:  /srv/salt/dev/services,/srv/salt/dev/states
#   prod: /srv/salt/prod/services,/srv/salt/prod/states
#
# Zusätzlich:
#   - Rollen- und Plattformstruktur (Proxmox, Cloud, DigitalHabitat)
#   - Pillar-Struktur mit dev/prod
#
# Idempotent: vorhandene Dateien werden NICHT überschrieben.

set -euo pipefail

BASE_DIR="/srv"
SALT_DIR="${BASE_DIR}/salt"
PILLAR_DIR="${BASE_DIR}/pillar"

log() {
  printf '[init-sxplr-salt-tree] %s\n' "$*"
}

create_dir() {
  local dir="$1"
  if [[ ! -d "$dir" ]]; then
    mkdir -p "$dir"
    log "Created directory: $dir"
  else
    log "Directory exists, skipping: $dir"
  fi
}

create_file_if_missing() {
  local file="$1"
  local content="$2"
  if [[ -e "$file" ]]; then
    log "File exists, skipping: $file"
  else
    printf '%s\n' "$content" > "$file"
    log "Created file: $file"
  fi
}

log "Starting Salt repository bootstrap under ${BASE_DIR}"

# ---------------------------------------------------------------------------
# 1. Verzeichnisse für States (file_roots)
# ---------------------------------------------------------------------------

# base env
create_dir "${SALT_DIR}"
create_dir "${SALT_DIR}/common"
create_dir "${SALT_DIR}/roles"
create_dir "${SALT_DIR}/proxmox/cluster"
create_dir "${SALT_DIR}/proxmox/node"
create_dir "${SALT_DIR}/cloud/proxmox"
create_dir "${SALT_DIR}/cloud/gcp"
create_dir "${SALT_DIR}/cloud/yandex"
create_dir "${SALT_DIR}/digital_habitat"
create_dir "${SALT_DIR}/orchestrate"
create_dir "${SALT_DIR}/modules"
create_dir "${SALT_DIR}/utils"
create_dir "${SALT_DIR}/formulas"        # für externe Formulas (Git-Submodules etc.)

# dev env
create_dir "${SALT_DIR}/dev"
create_dir "${SALT_DIR}/dev/states"
create_dir "${SALT_DIR}/dev/services"

# prod env
create_dir "${SALT_DIR}/prod"
create_dir "${SALT_DIR}/prod/states"
create_dir "${SALT_DIR}/prod/services"

# ---------------------------------------------------------------------------
# 2. Verzeichnisse für Pillar
# ---------------------------------------------------------------------------

create_dir "${PILLAR_DIR}"
create_dir "${PILLAR_DIR}/proxmox"
create_dir "${PILLAR_DIR}/cloud"
create_dir "${PILLAR_DIR}/digital_habitat"
create_dir "${PILLAR_DIR}/dev"
create_dir "${PILLAR_DIR}/prod"
create_dir "${PILLAR_DIR}/secrets.example"

# ---------------------------------------------------------------------------
# 3. README / Dokumentation
# ---------------------------------------------------------------------------

SALT_README_CONTENT="# sxplr-salt-repo

Dieses Repository bildet die Konfiguration der sxplr / grrtnr Infrastruktur ab.

Struktur (States):
- base:   ${SALT_DIR}
  - common/            # plattformübergreifende Basis-States
  - roles/             # rollenbasierte States (web, db, gateway, proxmox-node, etc.)
  - proxmox/           # Proxmox Cluster & Node States
  - cloud/             # Cloud-spezifische States (Proxmox-Cloud, GCP, Yandex)
  - digital_habitat/   # Mesh / #DigitalHabitat-relevante States (WireGuard, VRF, etc.)
  - orchestrate/       # Orchestrate-States (Cluster-weite Aktionen)
  - modules/           # eigene Execution-/State-Module
  - utils/             # Hilfs-States, Macros
  - formulas/          # externe Formulas (als Git-Submodule o.ä.)

- dev:   ${SALT_DIR}/dev
  - states/            # experimentelle / Entwicklungs-States
  - services/          # service-spezifische Dev-States

- prod:  ${SALT_DIR}/prod
  - states/            # produktive Abwandlungen spezieller States
  - services/          # produktive service-spezifische States

Pillar:
- ${PILLAR_DIR}/proxmox/        # Cluster-Topologie, Node-Mapping, Storage, SDN/VRF
- ${PILLAR_DIR}/cloud/          # Cloud-spezifische Parameter
- ${PILLAR_DIR}/digital_habitat # P2P/Mesh-spezifische Konfigurationen
- ${PILLAR_DIR}/dev/            # Dev-spezifische Pillars
- ${PILLAR_DIR}/prod/           # Prod-spezifische Pillars
- ${PILLAR_DIR}/secrets.example # Beispiel für geheime Daten (Vault/SOPS/extern)

Empfohlen:
- GitFS nutzen (z.B. https://github.com/hdaipteam/sxplr-salt-repo)
- Secrets nicht im Klartext speichern, sondern via Vault/SOPS einbinden.
"

create_file_if_missing "${SALT_DIR}/README.md" "${SALT_README_CONTENT}"

# ---------------------------------------------------------------------------
# 4. top.sls für States (base/dev/prod)
# ---------------------------------------------------------------------------

SALT_TOP_CONTENT="base:
  '*':
    - common.init
    - proxmox.cluster.init
    - roles.base

dev:
  'env:dev':
    - match: grain
    - dev.states.init

prod:
  'env:prod':
    - match: grain
    - prod.states.init
"

create_file_if_missing "${SALT_DIR}/top.sls" "${SALT_TOP_CONTENT}"

# ---------------------------------------------------------------------------
# 5. Erste State-Skelette (base)
# ---------------------------------------------------------------------------

COMMON_INIT_CONTENT="# common/init.sls
#
# Basis-States, die auf allen Nodes angewendet werden können (Host-unabhängig):
# - grundlegende Pakete
# - Zeitsynchronisation
# - Logging-Basiskonfiguration
#

common-packages:
  pkg.installed:
    - pkgs:
      - vim
      - htop
      - curl
      - jq
      - net-tools

time-sync:
  service.running:
    - name: systemd-timesyncd
    - enable: true
"

create_file_if_missing "${SALT_DIR}/common/init.sls" "${COMMON_INIT_CONTENT}"

ROLES_BASE_CONTENT="# roles/base/init.sls
#
# Basis-Rolle, die alle Nodes erhalten (zusätzlich zu common).
#

include:
  - common

# Platzhalter für weitere, rollenunabhängige Konfigurationen.
"

create_file_if_missing "${SALT_DIR}/roles/base.sls" "${ROLES_BASE_CONTENT}"

PROXMOX_CLUSTER_INIT_CONTENT="# proxmox/cluster/init.sls
#
# States zur Abbildung des Proxmox VE Clusters (Version 9),
# inkl. WireGuard-Overlay, VRF/SDN-Basiskonfiguration (mittels Proxmox SDN),
# und Host-spezifischen Unterschieden (WORK-/STOR-Node).
#

{% set cluster = pillar.get('proxmox', {}) %}

# Beispiel: sicherstellen, dass Proxmox-Basisdienste laufen
pve-services:
  service.running:
    - name: pvedaemon
    - enable: true

pve-cluster-service:
  service.running:
    - name: pve-cluster
    - enable: true

# WireGuard/Overlay kann in separaten States (z.B. roles/proxmox_wg) behandelt werden.
"

create_file_if_missing "${SALT_DIR}/proxmox/cluster/init.sls" "${PROXMOX_CLUSTER_INIT_CONTENT}"

PROXMOX_NODE_INIT_CONTENT="# proxmox/node/init.sls
#
# Node-spezifische Konfiguration (WORK vs. STOR), gesteuert über grains:
# role: pve-work / pve-stor
#

{% set role = grains.get('role', '') %}

{% if role == 'pve-work' %}
include:
  - roles.proxmox_work
{% elif role == 'pve-stor' %}
include:
  - roles.proxmox_stor
{% endif %}
"

create_file_if_missing "${SALT_DIR}/proxmox/node/init.sls" "${PROXMOX_NODE_INIT_CONTENT}"

ROLES_PVE_WORK_CONTENT="# roles/proxmox_work.sls
#
# Rolle für Proxmox WORK-Node:
# - KVM/Gast-spezifische Optimierungen
# - ggf. Web-/Frontend-Komponenten für Management
#

pve-work-marker:
  test.nop:
    - comment: 'Proxmox WORK node role applied.'
"

create_file_if_missing "${SALT_DIR}/roles/proxmox_work.sls" "${ROLES_PVE_WORK_CONTENT}"

ROLES_PVE_STOR_CONTENT="# roles/proxmox_stor.sls
#
# Rolle für Proxmox STOR-Node:
# - Storage-spezifische Konfiguration (ZFS, Ceph, NFS, etc.)
#

pve-stor-marker:
  test.nop:
    - comment: 'Proxmox STOR node role applied.'
"

create_file_if_missing "${SALT_DIR}/roles/proxmox_stor.sls" "${ROLES_PVE_STOR_CONTENT}"

# Dev / Prod Init States
DEV_INIT_CONTENT="# dev/states/init.sls
#
# Entwicklungs-spezifische States, z.B. experimentelle Konfigurationen
# oder nicht produktiv freigegebene Features.
#

dev-marker:
  test.nop:
    - comment: 'Dev environment state applied.'
"

create_file_if_missing "${SALT_DIR}/dev/states/init.sls" "${DEV_INIT_CONTENT}"

PROD_INIT_CONTENT="# prod/states/init.sls
#
# Produktiv-spezifische States, z.B. streng gehärtete Konfigurationen
# oder produktive Service-Tunings.
#

prod-marker:
  test.nop:
    - comment: 'Prod environment state applied.'
"

create_file_if_missing "${SALT_DIR}/prod/states/init.sls" "${PROD_INIT_CONTENT}"

# ---------------------------------------------------------------------------
# 6. Pillar top.sls und Basis-Pillars
# ---------------------------------------------------------------------------

PILLAR_TOP_CONTENT="base:
  '*':
    - proxmox.cluster

dev:
  'env:dev':
    - match: grain
    - dev.env

prod:
  'env:prod':
    - match: grain
    - prod.env
"

create_file_if_missing "${PILLAR_DIR}/top.sls" "${PILLAR_TOP_CONTENT}"

PILLAR_PROXMOX_CLUSTER_CONTENT="# pillar/proxmox/cluster.sls
#
# Pillar-Daten zur Beschreibung des Proxmox Clusters (sxplr-ovh).
# Diese Daten werden in proxmox/cluster/init.sls verwendet.
#

proxmox:
  cluster_name: sxplr-ovh
  nodes:
    - sxplr-ovh-work-node-001
    - sxplr-ovh-work-node-002
    - sxplr-ovh-stor-node-001
  network:
    wg_iface: wg0
    overlay_cidr: 10.99.0.0/24
  sdn:
    vrf:
      enabled: true
      # Weitere VRF/SDN-Spezifika werden über Proxmox SDN gemanagt,
      # Salt kann hier Parameter, Policies und ACLs abbilden.
"

create_file_if_missing "${PILLAR_DIR}/proxmox/cluster.sls" "${PILLAR_PROXMOX_CLUSTER_CONTENT}"

PILLAR_DEV_ENV_CONTENT="# pillar/dev/env.sls
env_name: dev
"

create_file_if_missing "${PILLAR_DIR}/dev/env.sls" "${PILLAR_DEV_ENV_CONTENT}"

PILLAR_PROD_ENV_CONTENT="# pillar/prod/env.sls
env_name: prod
"

create_file_if_missing "${PILLAR_DIR}/prod/env.sls" "${PILLAR_PROD_ENV_CONTENT}"

PILLAR_SECRETS_EXAMPLE_CONTENT="# pillar/secrets.example/README.md
#
# Hier KEINE echten Secrets ablegen.
# Stattdessen:
# - HashiCorp Vault
# - SOPS (age/GPG) + verschlüsselte Pillar-Files
#
# Beispiel:
#   db_password: {{ salt['vault.read_secret']('secret/prod/db')['password'] }}
"

create_file_if_missing "${PILLAR_DIR}/secrets.example/README.md" "${PILLAR_SECRETS_EXAMPLE_CONTENT}"

log "Salt repository bootstrap completed."
