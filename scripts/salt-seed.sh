#!/usr/bin/env bash
#
# salt-seed.sh
# Bootstrap-Script für Proxmox VE 9 Nodes (Debian 13 / Trixie),
# um WireGuard + salt-minion (masterless) + Git-basierte Salt-Struktur zu initialisieren.
#
# Design-Ziele:
# - Idempotent: mehrfach ausführbar ohne Schaden
# - Log-basiert: schreibt alle Schritte nach /var/log/salt-seed.log
# - Klar getrennte Verantwortlichkeiten:
#   * Netzwerk (WireGuard)
#   * Salt-Minions (masterless)
#   * GitFS-artige Struktur unter /srv/salt & /srv/pillar
#   * einfache Erweiterbarkeit für spätere Master-Anbindung
#
set -euo pipefail

LOG_FILE="/var/log/salt-seed.log"

WG_INTERFACE="${WG_INTERFACE:-wg0}"
WG_ADDRESS="${WG_ADDRESS:-10.99.0.11/24}"     # bitte je Node anpassen oder per ENV setzen
WG_CONFIG_URL="${WG_CONFIG_URL:-}"           # optional: URL zu fertiger wg0.conf

SALT_ENV="${SALT_ENV:-dev}"                  # dev oder prod
SALT_ROLE="${SALT_ROLE:-pve-work}"           # z. B. pve-work, pve-stor
SALT_DOMAIN="${SALT_DOMAIN:-sxplr-ovh}"      # z. B. sxplr-ovh

GIT_REPO_URL="${GIT_REPO_URL:-https://github.com/hdaipteam/sxplr-salt-repo}"
GIT_BASE_DIR="/srv/sxplr-salt-repo"

SALT_BASE_DIR="/srv/salt"
PILLAR_BASE_DIR="/srv/pillar"

###############################################################################
# Helper
###############################################################################
log() {
  local msg="$1"
  echo "$(date '+%Y-%m-%d %H:%M:%S') [salt-seed] ${msg}" | tee -a "${LOG_FILE}"
}

require_root() {
  if [[ "$(id -u)" -ne 0 ]]; then
    echo "Dieses Script muss als root ausgeführt werden." >&2
    exit 1
  fi
}

run_or_warn() {
  local cmd="$*"
  if ! eval "${cmd}"; then
    log "WARN: Kommando fehlgeschlagen: ${cmd}"
  fi
}

###############################################################################
# 1. Basis-Checks
###############################################################################
require_root
log "Starte salt-seed Bootstrap..."

log "System-Informationen:"
log "  Hostname: $(hostname -f || hostname)"
log "  OS: $(grep PRETTY_NAME /etc/os-release | cut -d= -f2- || echo 'unknown')"
log "  WG_INTERFACE=${WG_INTERFACE} WG_ADDRESS=${WG_ADDRESS}"
log "  SALT_ENV=${SALT_ENV} SALT_ROLE=${SALT_ROLE} SALT_DOMAIN=${SALT_DOMAIN}"
log "  Git-Repo: ${GIT_REPO_URL}"

###############################################################################
# 2. Paket-Basis (curl, git, etc.)
###############################################################################
log "Installiere Basis-Pakete (curl, git, jq, wireguard-Tools, etc.)..."
apt-get update -y >>"${LOG_FILE}" 2>&1
apt-get install -y curl git jq wireguard wireguard-tools >>"${LOG_FILE}" 2>&1

###############################################################################
# 3. WireGuard-Grundkonfiguration (falls noch nicht vorhanden)
###############################################################################
if [[ -n "${WG_CONFIG_URL}" ]]; then
  log "Hole WireGuard-Konfiguration aus WG_CONFIG_URL=${WG_CONFIG_URL}..."
  mkdir -p /etc/wireguard
  curl -fsSL "${WG_CONFIG_URL}" -o "/etc/wireguard/${WG_INTERFACE}.conf"
  chmod 600 "/etc/wireguard/${WG_INTERFACE}.conf"
else
  if [[ -f "/etc/wireguard/${WG_INTERFACE}.conf" ]]; then
    log "WireGuard-Konfiguration /etc/wireguard/${WG_INTERFACE}.conf existiert bereits – überspringe Erstellung."
  else
    log "Erzeuge minimale lokale WireGuard-Konfiguration für ${WG_INTERFACE}..."
    mkdir -p /etc/wireguard
    umask 077
    if [[ ! -f "/etc/wireguard/${WG_INTERFACE}.key" ]]; then
      wg genkey | tee "/etc/wireguard/${WG_INTERFACE}.key" > "/etc/wireguard/${WG_INTERFACE}.pub"
      chmod 600 "/etc/wireguard/${WG_INTERFACE}.key"
    fi
    PRIVATE_KEY="$(cat "/etc/wireguard/${WG_INTERFACE}.key")"

    cat >"/etc/wireguard/${WG_INTERFACE}.conf" <<EOF
[Interface]
PrivateKey = ${PRIVATE_KEY}
Address = ${WG_ADDRESS}
ListenPort = 51820

# TODO: Peers (Proxmox-Cluster, Master, Gateways) ergänzen:
# [Peer]
# PublicKey = <MASTER_PUBLIC_KEY>
# Endpoint = <MASTER_ENDPOINT>:51820
# AllowedIPs = 10.99.0.0/24
# PersistentKeepalive = 25
EOF
    chmod 600 "/etc/wireguard/${WG_INTERFACE}.conf"
  fi
fi

log "Aktiviere und starte WireGuard-Interface ${WG_INTERFACE}..."
run_or_warn "systemctl enable wg-quick@${WG_INTERFACE}"
run_or_warn "systemctl restart wg-quick@${WG_INTERFACE}"

###############################################################################
# 4. Salt-Minon Installation (Masterless-Setup)
###############################################################################
log "Installiere salt-minion (masterless-Konfiguration)..."

# HINWEIS:
# Aufgrund der Repo-Migration des Salt-Projekts können ältere Anleitungen mit
# repo.saltproject.io nicht mehr funktionieren. Für Debian/Proxmox VE 9 (Trixie)
# empfiehlt sich, entweder:
#   - Salt aus den Debian-Repos zu nutzen, sobald verfügbar, oder
#   - einen eigenen Mirror / .deb Bereitstellung zu machen.
#
# Hier verwenden wir vorerst das Distributionspaket, das du bei Bedarf anpassen kannst.
#
apt-get install -y salt-minion >>"${LOG_FILE}" 2>&1 || {
  log "WARN: salt-minion konnte nicht installiert werden. Bitte Salt-Repo manuell prüfen/anpassen."
}

if ! command -v salt-minion >/dev/null 2>&1; then
  log "FEHLER: salt-minion ist nach Installation nicht verfügbar. Abbruch."
  exit 1
fi

log "Konfiguriere salt-minion für masterless-Modus..."
mkdir -p /etc/salt/minion.d

cat >/etc/salt/minion.d/masterless.conf <<EOF
file_client: local

file_roots:
  base:
    - ${SALT_BASE_DIR}/
  dev:
    - ${SALT_BASE_DIR}/dev/services
    - ${SALT_BASE_DIR}/dev/states
  prod:
    - ${SALT_BASE_DIR}/prod/services
    - ${SALT_BASE_DIR}/prod/states

pillar_roots:
  base:
    - ${PILLAR_BASE_DIR}/base
  dev:
    - ${PILLAR_BASE_DIR}/dev
  prod:
    - ${PILLAR_BASE_DIR}/prod
EOF

log "Setze minion_id & Grains..."
MINION_ID="$(hostname -f || hostname)"
echo "${MINION_ID}" >/etc/salt/minion_id

# Grains werden in einer eigenen Datei abgelegt
cat >/etc/salt/minion.d/grains.conf <<EOF
grains:
  role: ${SALT_ROLE}
  env: ${SALT_ENV}
  domain: ${SALT_DOMAIN}
  wg_interface: ${WG_INTERFACE}
EOF

log "Aktiviere und starte salt-minion..."
systemctl enable salt-minion >>"${LOG_FILE}" 2>&1 || true
systemctl restart salt-minion >>"${LOG_FILE}" 2>&1 || true

###############################################################################
# 5. Git-Repository mit Salt-Struktur klonen / aktualisieren
###############################################################################
log "Klonen/Aktualisieren des Git-Repos ${GIT_REPO_URL} nach ${GIT_BASE_DIR}..."

if [[ -d "${GIT_BASE_DIR}/.git" ]]; then
  log "Git-Repo bereits vorhanden – hole Updates..."
  git -C "${GIT_BASE_DIR}" pull >>"${LOG_FILE}" 2>&1 || log "WARN: git pull fehlgeschlagen"
else
  mkdir -p "$(dirname "${GIT_BASE_DIR}")"
  git clone "${GIT_REPO_URL}" "${GIT_BASE_DIR}" >>"${LOG_FILE}" 2>&1 || {
    log "WARN: git clone von ${GIT_REPO_URL} fehlgeschlagen – bitte manuell prüfen."
  }
fi

###############################################################################
# 6. /srv/salt & /srv/pillar Struktur anlegen & mit Repo verbinden
###############################################################################
log "Erzeuge/verknüpfe Salt-Verzeichnisstruktur unter ${SALT_BASE_DIR} und ${PILLAR_BASE_DIR}..."

mkdir -p "${SALT_BASE_DIR}/dev/services" \
         "${SALT_BASE_DIR}/dev/states" \
         "${SALT_BASE_DIR}/prod/services" \
         "${SALT_BASE_DIR}/prod/states"

mkdir -p "${PILLAR_BASE_DIR}/base" \
         "${PILLAR_BASE_DIR}/dev" \
         "${PILLAR_BASE_DIR}/prod"

# Vorschlag: das Repo wird nach /srv/sxplr-salt-repo geklont, darin liegen:
#   salt/...
#   pillar/...
# Diese können wir mit Symlinks in die erwartete Struktur einhängen.

if [[ -d "${GIT_BASE_DIR}/salt" ]]; then
  log "Verknüpfe ${GIT_BASE_DIR}/salt mit ${SALT_BASE_DIR}..."
  # nur symlinken, wenn leer
  if [[ -z "$(ls -A "${SALT_BASE_DIR}")" ]]; then
    rmdir "${SALT_BASE_DIR}" 2>/dev/null || true
    ln -s "${GIT_BASE_DIR}/salt" "${SALT_BASE_DIR}"
  else
    log "WARN: ${SALT_BASE_DIR} ist nicht leer – Symlink wird nicht gesetzt."
  fi
else
  log "WARN: Im Repo wurde kein Unterordner 'salt' gefunden."
fi

if [[ -d "${GIT_BASE_DIR}/pillar" ]]; then
  log "Verknüpfe ${GIT_BASE_DIR}/pillar mit ${PILLAR_BASE_DIR}..."
  if [[ -z "$(ls -A "${PILLAR_BASE_DIR}")" ]]; then
    rmdir "${PILLAR_BASE_DIR}" 2>/dev/null || true
    ln -s "${GIT_BASE_DIR}/pillar" "${PILLAR_BASE_DIR}"
  else
    log "WARN: ${PILLAR_BASE_DIR} ist nicht leer – Symlink wird nicht gesetzt."
  fi
else
  log "WARN: Im Repo wurde kein Unterordner 'pillar' gefunden."
fi

###############################################################################
# 7. Testlauf eines einfachen States (falls vorhanden)
###############################################################################
log "Führe einen ersten Testlauf mit salt-call state.apply aus (sofern States vorhanden)..."
run_or_warn "salt-call --local state.apply test --log-level=info"

log "salt-seed Bootstrap abgeschlossen."
exit 0
################################################################################ Ende
