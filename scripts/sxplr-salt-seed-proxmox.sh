#!/usr/bin/env bash
#
# sxplr-salt-seed-proxmox.sh
#
# Bootstrap-Skript für einen Proxmox VE 9 Node:
# - Installiert Salt Minion via salt-bootstrap (neu, GitHub-Releases)
# - Konfiguriert masterless-Betrieb (file_client: local)
# - Klont sxplr-salt-repo nach /srv/salt
# - Richtet systemd-Abhängigkeit zu WireGuard (wg-quick@wg0) ein
#
# Aufruf (als root):
#   curl -O https://raw.githubusercontent.com/hdaipteam/sxplr-salt-repo/main/tools/sxplr-salt-seed-proxmox.sh
#   chmod +x sxplr-salt-seed-proxmox.sh
#   ./sxplr-salt-seed-proxmox.sh
#

set -euo pipefail

LOG_FILE="/var/log/sxplr-salt-seed.log"

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $*" | tee -a "${LOG_FILE}"
}

REPO_URL_DEFAULT="https://github.com/hdaipteam/sxplr-salt-repo.git"
REPO_URL="${REPO_URL_DEFAULT}"
REPO_TARGET="/srv/salt"
WG_UNIT="wg-quick@wg0.service"

log "Starte sxplr-salt-seed Bootstrap für Proxmox-Node"

########################################
# 0. Parameter optional (z.B. alternativer Repo-URL)
########################################

if [[ "${1-}" != "" ]]; then
  REPO_URL="$1"
  log "Verwende alternativen Git-Repo-URL: ${REPO_URL}"
else
  log "Verwende Standard-Git-Repo-URL: ${REPO_URL}"
fi

########################################
# 1. Basis-Pakete
########################################

log "Update der Paketquellen..."
apt-get update -y

log "Installation von Basis-Tools (curl, git, ca-certificates)..."
apt-get install -y curl git ca-certificates

########################################
# 2. Salt via salt-bootstrap installieren
########################################

# Hinweis: Bootstrap-Skript direkt von GitHub Releases (offiziell empfohlen).
# Siehe: https://github.com/saltstack/salt-bootstrap :contentReference[oaicite:2]{index=2}

BOOTSTRAP="/tmp/bootstrap-salt.sh"

if [[ ! -f "${BOOTSTRAP}" ]]; then
  log "Lade salt-bootstrap Script von GitHub Releases herunter..."
  curl -fsSL -o "${BOOTSTRAP}" \
    "https://github.com/saltstack/salt-bootstrap/releases/latest/download/bootstrap-salt.sh"
fi

log "Führe salt-bootstrap aus (installiere Salt Minion, aktuelle stable-Pakete)..."
sh "${BOOTSTRAP}" -P stable

log "Salt-Minon Installation abgeschlossen."

########################################
# 3. repo nach /srv/salt klonen oder aktualisieren
########################################

if [[ -d "${REPO_TARGET}/.git" ]]; then
  log "Git-Repository in ${REPO_TARGET} existiert bereits, führe git pull aus..."
  (cd "${REPO_TARGET}" && git pull --ff-only) || {
    log "WARNUNG: git pull fehlgeschlagen, bitte manuell prüfen."
  }
else
  log "Klone Git-Repository ${REPO_URL} nach ${REPO_TARGET}..."
  # /srv existiert i.d.R. bereits, falls nicht:
  mkdir -p /srv
  git clone "${REPO_URL}" "${REPO_TARGET}"
fi

########################################
# 4. Masterless Minion konfigurieren
########################################

MINION_CONF="/etc/salt/minion"

log "Konfiguriere /etc/salt/minion für masterless-Betrieb..."

mkdir -p /etc/salt

# FQDN als Minion-ID (oder was du bevorzugst)
MINION_ID="$(hostname -f || hostname)"

cat > "${MINION_CONF}" << EOF
# /etc/salt/minion - masterless Konfiguration für Proxmox-Node

id: ${MINION_ID}

file_client: local

file_roots:
  base:
    - /srv/salt/srv/salt/base
  dev:
    - /srv/salt/srv/salt/dev
  prod:
    - /srv/salt/srv/salt/prod

pillar_roots:
  base:
    - /srv/salt/srv/pillar/base
  dev:
    - /srv/salt/srv/pillar/dev
  prod:
    - /srv/salt/srv/pillar/prod

# Optional: Logging etwas ausführlicher während der Entwicklungsphase
log_level: info
EOF

log "Minion-Konfiguration geschrieben. Minion-ID: ${MINION_ID}"

########################################
# 5. systemd-Abhängigkeit zu WireGuard / VRF
########################################

# Idee: Salt-Minon sollte NACH WireGuard/SDN/VRF bereitstehen, falls später
# doch ein zentraler Master oder externe Ressourcen genutzt werden.

log "Passe systemd-Unit von salt-minion an (Abhängigkeit zu WireGuard)..."

SYSTEMD_DROPIN_DIR="/etc/systemd/system/salt-minion.service.d"
mkdir -p "${SYSTEMD_DROPIN_DIR}"

cat > "${SYSTEMD_DROPIN_DIR}/override.conf" << EOF
[Unit]
After=${WG_UNIT}
Wants=${WG_UNIT}
EOF

log "systemd Drop-In für salt-minion erstellt: ${SYSTEMD_DROPIN_DIR}/override.conf"

systemctl daemon-reload

########################################
# 6. Salt-Minon aktivieren und starten (masterless)
########################################

log "Aktiviere und starte salt-minion (masterless)..."
systemctl enable salt-minion
systemctl restart salt-minion

########################################
# 7. Probelauf eines lokalen State (falls bereits vorhanden)
########################################

if [[ -f "${REPO_TARGET}/srv/salt/base/top.sls" ]]; then
  log "Führe Test-Highstate im lokalen Modus aus (salt-call state.apply)..."
  salt-call --local state.apply || log "WARNUNG: Highstate schlug fehl, bitte States prüfen."
else
  log "Hinweis: Noch kein base/top.sls im Repo gefunden – kein Highstate ausgeführt."
fi

log "sxplr-salt-seed Bootstrap abgeschlossen."
