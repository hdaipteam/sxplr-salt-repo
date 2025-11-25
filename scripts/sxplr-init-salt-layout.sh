#!/usr/bin/env bash
#
# sxplr-init-salt-layout.sh
#
# Initialisiert die Basis-Verzeichnisstruktur für das Salt-Repo
# "sxplr-salt-repo" nach Best Practices (base/dev/prod, roles/profiles usw.).
#
# Ausführung:
#   cd ~/01-01_HDaIP-cloud/sxplr-salt-repo
#   chmod +x sxplr-init-salt-layout.sh
#   ./sxplr-init-salt-layout.sh
#

set -euo pipefail

REPO_ROOT="$(pwd)"
LOG_FILE="${REPO_ROOT}/sxplr-init-salt-layout.log"

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $*" | tee -a "${LOG_FILE}"
}

log "Starte Initialisierung des Salt-Layouts im Repo: ${REPO_ROOT}"

# Basisverzeichnisse nach deiner file_roots-Logik
# base -> generische States
# dev/prod -> environments mit services/states, optional cloud-spezifisch
DIRS=(
  "srv/salt/base/roles"
  "srv/salt/base/profiles"
  "srv/salt/base/infra/proxmox"
  "srv/salt/base/infra/network"
  "srv/salt/base/infra/security"
  "srv/salt/base/apps/web"
  "srv/salt/base/apps/db"
  "srv/salt/base/orchestrate"

  "srv/salt/dev/services"
  "srv/salt/dev/states"
  "srv/salt/dev/cloud/gcp"
  "srv/salt/dev/cloud/yandex"
  "srv/salt/dev/cloud/firebase"

  "srv/salt/prod/services"
  "srv/salt/prod/states"
  "srv/salt/prod/cloud/gcp"
  "srv/salt/prod/cloud/yandex"
  "srv/salt/prod/cloud/firebase"

  "srv/pillar/base"
  "srv/pillar/dev"
  "srv/pillar/prod"

  "doc"
)

for d in "${DIRS[@]}"; do
  full="${REPO_ROOT}/${d}"
  if [[ ! -d "${full}" ]]; then
    log "Erzeuge Verzeichnis: ${d}"
    mkdir -p "${full}"
  else
    log "Verzeichnis existiert bereits: ${d}"
  fi
done

########################################
# top.sls für Salt States (base/dev/prod)
########################################

TOP_BASE="${REPO_ROOT}/srv/salt/base/top.sls"
if [[ ! -f "${TOP_BASE}" ]]; then
  log "Erzeuge ${TOP_BASE}"
  cat > "${TOP_BASE}" << 'EOF'
# srv/salt/base/top.sls
# Globale Zuweisung von States für alle Minions (Basislayer)

base:
  '*':
    - infra.proxmox.base
    - infra.network.base
    - infra.security.ssh
EOF
fi

TOP_DEV="${REPO_ROOT}/srv/salt/dev/top.sls"
if [[ ! -f "${TOP_DEV}" ]]; then
  log "Erzeuge ${TOP_DEV}"
  cat > "${TOP_DEV}" << 'EOF'
# srv/salt/dev/top.sls
# Entwicklungs-spezifische States (z.B. zusätzliche Debug-Tools)

dev:
  '*':
    - dev.services.common
EOF
fi

TOP_PROD="${REPO_ROOT}/srv/salt/prod/top.sls"
if [[ ! -f "${TOP_PROD}" ]]; then
  log "Erzeuge ${TOP_PROD}"
  cat > "${TOP_PROD}" << 'EOF'
# srv/salt/prod/top.sls
# Produktions-spezifische States

prod:
  '*':
    - prod.services.monitoring
EOF
fi

########################################
# pillar top.sls (base/dev/prod)
########################################

PILLAR_TOP_BASE="${REPO_ROOT}/srv/pillar/base/top.sls"
if [[ ! -f "${PILLAR_TOP_BASE}" ]]; then
  log "Erzeuge ${PILLAR_TOP_BASE}"
  cat > "${PILLAR_TOP_BASE}" << 'EOF'
# srv/pillar/base/top.sls
# Basis-Pillars (clusterweite Einstellungen)

base:
  '*':
    - global.settings
EOF
fi

PILLAR_TOP_DEV="${REPO_ROOT}/srv/pillar/dev/top.sls"
if [[ ! -f "${PILLAR_TOP_DEV}" ]]; then
  log "Erzeuge ${PILLAR_TOP_DEV}"
  cat > "${PILLAR_TOP_DEV}" << 'EOF'
# srv/pillar/dev/top.sls
# Entwicklungs-spezifische Pillars

dev:
  '*':
    - dev.settings
EOF
fi

PILLAR_TOP_PROD="${REPO_ROOT}/srv/pillar/prod/top.sls"
if [[ ! -f "${PILLAR_TOP_PROD}" ]]; then
  log "Erzeuge ${PILLAR_TOP_PROD}"
  cat > "${PILLAR_TOP_PROD}" << 'EOF'
# srv/pillar/prod/top.sls
# Produktions-spezifische Pillars

prod:
  '*':
    - prod.settings
EOF
fi

########################################
# Beispiel-State für Proxmox-Basis
########################################

PROXMOX_BASE="${REPO_ROOT}/srv/salt/base/infra/proxmox/base.sls"
if [[ ! -f "${PROXMOX_BASE}" ]]; then
  log "Erzeuge ${PROXMOX_BASE}"
  cat > "${PROXMOX_BASE}" << 'EOF'
# srv/salt/base/infra/proxmox/base.sls
# Basis-Config für Proxmox VE-Knoten

include:
  - infra.security.ssh

base-packages:
  pkg.installed:
    - pkgs:
      - htop
      - jq
      - vim
      - net-tools
      - curl

pve-ssh-service:
  service.running:
    - name: ssh
    - enable: true
EOF
fi

########################################
# Beispiel-State für SSH-Hardening
########################################

SSH_STATE="${REPO_ROOT}/srv/salt/base/infra/security/ssh.sls"
if [[ ! -f "${SSH_STATE}" ]]; then
  log "Erzeuge ${SSH_STATE}"
  cat > "${SSH_STATE}" << 'EOF'
# srv/salt/base/infra/security/ssh.sls
# SSH-Hardening-Example

/etc/ssh/sshd_config:
  file.managed:
    - source: salt://infra/security/files/sshd_config.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: '0600'

sshd:
  service.running:
    - name: ssh
    - enable: true
EOF
fi

########################################
# README-Doku
########################################

README="${REPO_ROOT}/doc/README-sxplr-salt-repo.md"
if [[ ! -f "${README}" ]]; then
  log "Erzeuge ${README}"
  cat > "${README}" << 'EOF'
# sxplr-salt-repo

Dieses Repository enthält die SaltStack-Konfiguration für:

- Proxmox VE 9 Cluster (WORK-/STOR-Nodes, WireGuard, VRF/SDN)
- zukünftige Cloud-Erweiterungen (GCP, Yandex Cloud, Firebase BaaS)
- Experimente in Richtung #DigitalHabitat (Mesh P2P)

Struktur (kurz):

- srv/salt/base      → generische States (rollen-/profil-basiert)
- srv/salt/dev       → dev-Environment, zusätzliche States/Services
- srv/salt/prod      → prod-Environment
- srv/pillar         → Pillar-Daten (base/dev/prod)
- doc                → Dokumentation

EOF
fi

log "Initialisierung abgeschlossen. Du kannst jetzt die States und Pillars weiter ausarbeiten."
