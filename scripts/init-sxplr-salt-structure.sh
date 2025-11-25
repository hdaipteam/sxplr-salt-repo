#!/usr/bin/env bash
set -euo pipefail

# Basis-Verzeichnisse für Salt States & Pillar
SALT_ROOT="/srv/salt"
PILLAR_ROOT="/srv/pillar"

echo ">>> Erzeuge Basis-Verzeichnisse unter:"
echo "    SALT_ROOT   = ${SALT_ROOT}"
echo "    PILLAR_ROOT = ${PILLAR_ROOT}"
echo

mkdir -p "${SALT_ROOT}"
mkdir -p "${PILLAR_ROOT}"

###############################################################################
# 1. BASE-ENV: /srv/salt (plattformübergreifende Struktur)
###############################################################################

# Common & Lib
mkdir -p "${SALT_ROOT}/common"
mkdir -p "${SALT_ROOT}/lib/macros"

# Plattform-Spezifika
mkdir -p "${SALT_ROOT}/proxmox/cluster"
mkdir -p "${SALT_ROOT}/proxmox/web_platform"
mkdir -p "${SALT_ROOT}/cloud/gcp"
mkdir -p "${SALT_ROOT}/cloud/yandex"
mkdir -p "${SALT_ROOT}/cloud/firebase"
mkdir -p "${SALT_ROOT}/digital_habitat/core"
mkdir -p "${SALT_ROOT}/digital_habitat/edge"

# README im Salt-Root
cat > "${SALT_ROOT}/README.md" << 'EOF'
# sxplr Salt States

Dieses Repository bildet die Basis der SXPLR Salt-Architektur:

- Proxmox VE 9 Cluster (WORK-/STOR-Nodes, WireGuard, VRF, Proxmox SDN)
- Cloud-Plattformen (GCP, Yandex, Firebase)
- #DigitalHabitat (Mesh P2P, WireGuard-only, VRF-Architektur)

Struktur (BASE-ENV, file_roots: base):
- /srv/salt/common/          → generische, plattformunabhängige States
- /srv/salt/lib/macros/      → wiederverwendbare Jinja-/State-Makros
- /srv/salt/proxmox/         → Proxmox-spezifische States (Cluster, Web-Plattform)
- /srv/salt/cloud/           → GCP/Yandex/Firebase-spezifische States
- /srv/salt/digital_habitat/ → #DigitalHabitat-spezifische States

Environment-spezifische States liegen unter:
- /srv/salt/dev/services, /srv/salt/dev/states
- /srv/salt/prod/services, /srv/salt/prod/states
EOF

# base/top.sls
cat > "${SALT_ROOT}/top.sls" << 'EOF'
# Globale top.sls für ENV "base"
# Hier nur sehr generische States anhängen. Spezifisches Matching über dev/prod top.sls.

base:
  '*':
    - common.init
EOF

# common/init.sls
cat > "${SALT_ROOT}/common/init.sls" << 'EOF'
# Common Baseline für alle Nodes (unabhängig von Plattform/ENV)

common-packages:
  pkg.installed:
    - pkgs:
      - vim
      - htop
      - curl
      - jq

# Platzhalter für weitere allgemeine Baseline-States (Zeitzone, NTP, Logging, etc.)
EOF

# lib/macros/README
cat > "${SALT_ROOT}/lib/macros/README.md" << 'EOF'
# Jinja / State Macros

Hier liegen wiederverwendbare Jinja-Makros und State-Snippets, z.B.:

- map.jinja Loader
- Standard-Owner/Mode-Makros
- Plattform-Unterscheidung (os_family, cloud provider, role, env)
EOF

# Proxmox Cluster Skeleton
cat > "${SALT_ROOT}/proxmox/cluster/init.sls" << 'EOF'
# Proxmox Cluster Baseline (WORK-/STOR-Nodes)
# Fokus: Proxmox VE 9, SDN, VRF, WireGuard, Proxmox VE Firewall.

include:
  - proxmox.cluster.hardening
  - proxmox.cluster.monitoring
EOF

cat > "${SALT_ROOT}/proxmox/cluster/hardening.sls" << 'EOF'
# Proxmox Hardening (SSH, sysctl, Firewall-Baseline)
# TODO: mit Ergebnissen aus Discovery füllen.

sshd:
  service.running:
    - enable: True

# Platzhalter: sysctl, fail2ban, Proxmox VE Firewall Regeln, SDN/VRF-Baseline
EOF

cat > "${SALT_ROOT}/proxmox/cluster/monitoring.sls" << 'EOF'
# Proxmox Monitoring / Metriken
# TODO: Integration Prometheus/Grafana, node_exporter, Proxmox Exporter, etc.
EOF

cat > "${SALT_ROOT}/proxmox/cluster/map.jinja" << 'EOF'
{# Proxmox Cluster Mapping (#DigitalHabitat / SXPLR) #}
{# TODO: OS-, Role- und ENV-spezifische Defaults hier ablegen #}
{% set data = {
  'cluster_name': 'sxplr-ovh-cluster',
  'wireguard_iface': 'wg0',
  'mgmt_subnet': '10.99.0.0/24'
} %}
EOF

# Proxmox Web-Plattform Skeleton
cat > "${SALT_ROOT}/proxmox/web_platform/init.sls" << 'EOF'
# Web-Plattform auf Proxmox:
# - Frontend-/Backend-VMs
# - getrennte Tiers (DB, Storage)
# - Reverse-Proxy, TLS, etc.

include:
  - proxmox.web_platform.frontend
  - proxmox.web_platform.backend
  - proxmox.web_platform.database
EOF

cat > "${SALT_ROOT}/proxmox/web_platform/frontend.sls" << 'EOF'
# Frontend-Webserver (z.B. nginx/haproxy) auf Proxmox-VMs

# Platzhalter: nginx/haproxy, Let's Encrypt, VRF-Zuordnung, SDN-Security-Groups
EOF

cat > "${SALT_ROOT}/proxmox/web_platform/backend.sls" << 'EOF'
# Backend-Applikationsserver (z.B. Python/Node/Java) auf Proxmox-VMs

# Platzhalter: uwsgi/gunicorn, systemd-Units, App-Deploy
EOF

cat > "${SALT_ROOT}/proxmox/web_platform/database.sls" << 'EOF'
# DB-Tier (z.B. MariaDB/PostgreSQL) auf dedizierten Proxmox-VMs

# Platzhalter: DB-Installation, User/Schema aus Pillar/Vault, Backup-Jobs
EOF

# Cloud Skeletons
for cloud in gcp yandex firebase; do
  cat > "${SALT_ROOT}/cloud/${cloud}/init.sls" << EOF
# ${cloud^^} spezifische States
# TODO: Provider-spezifische Implementierung (VM-Deployment, IAM, Netz, etc.)
EOF
done

# Digital Habitat Skeletons
cat > "${SALT_ROOT}/digital_habitat/core/init.sls" << 'EOF'
# #DigitalHabitat Core:
# - Mesh-Overlay auf WireGuard
# - VRF-/Routing-Logik
# - Salt-Minions in Mesh-Topologie

# Platzhalter: Mesh-Bootstrap, VRF-Konfiguration, Routing-Policies
EOF

cat > "${SALT_ROOT}/digital_habitat/edge/init.sls" << 'EOF'
# #DigitalHabitat Edge Nodes:
# - Gateways zwischen Mesh und "klassischem Internet"
# - Traffic-Policies, NAT, Exit-Nodes

# Platzhalter: WireGuard-Peers, iptables/nftables, Policy-Routing
EOF

###############################################################################
# 2. DEV-/PROD-ENVs: /srv/salt/dev & /srv/salt/prod
###############################################################################

for env in dev prod; do
  echo ">>> Erzeuge ENV: ${env}"

  # Services & States gemäß file_roots
  mkdir -p "${SALT_ROOT}/${env}/services/proxmox"
  mkdir -p "${SALT_ROOT}/${env}/services/web"
  mkdir -p "${SALT_ROOT}/${env}/services/cloud"
  mkdir -p "${SALT_ROOT}/${env}/services/digital_habitat"

  mkdir -p "${SALT_ROOT}/${env}/states/base"
  mkdir -p "${SALT_ROOT}/${env}/states/experiments"

  # ENV-spezifische top.sls (werden in /etc/salt/master via env_order: ['base','dev','prod'] genutzt)
  cat > "${SALT_ROOT}/${env}/top.sls" << EOF
# top.sls für ENV "${env}"

${env}:
  'role:pve-*':
    - match: grain
    - proxmox.cluster
  'role:app-web':
    - match: grain
    - proxmox.web_platform
EOF

  # ENV-README
  cat > "${SALT_ROOT}/${env}/README.md" << EOF
# ENV: ${env}

- services/ : ENV-spezifische Service-Bundles (z.B. proxmox-hardening, web-stack)
- states/   : ENV-spezifische States (base, experiments)

Dieses ENV überschreibt und erweitert die globalen States aus /srv/salt (base).
EOF

done

###############################################################################
# 3. PILLAR-STRUKTUR
###############################################################################

mkdir -p "${PILLAR_ROOT}/env/dev"
mkdir -p "${PILLAR_ROOT}/env/prod"
mkdir -p "${PILLAR_ROOT}/proxmox"
mkdir -p "${PILLAR_ROOT}/cloud"
mkdir -p "${PILLAR_ROOT}/digital_habitat"
mkdir -p "${PILLAR_ROOT}/secrets"

# Pillar top.sls
cat > "${PILLAR_ROOT}/top.sls" << 'EOF'
# Globale Pillar top.sls

base:
  '*':
    - proxmox.cluster
    - digital_habitat.tenants

dev:
  'env:dev':
    - match: grain
    - env/dev/settings

prod:
  'env:prod':
    - match: grain
    - env/prod/settings
EOF

# Proxmox Cluster Pillar
cat > "${PILLAR_ROOT}/proxmox/cluster.sls" << 'EOF'
# Proxmox Cluster Pillar (WORK-/STOR-Nodes, WireGuard, VRF, SDN)

proxmox:
  cluster_name: sxplr-ovh-cluster
  nodes:
    - sxplr-ovh-work-node-001
    - sxplr-ovh-work-node-002
    - sxplr-ovh-stor-node-001
  network:
    wireguard_iface: wg0
    mgmt_subnet: 10.99.0.0/24
    vrf:
      enabled: true
      name: sxplrweb
  sdn:
    enabled: true
    zones: []
EOF

# Digital Habitat Pillar
cat > "${PILLAR_ROOT}/digital_habitat/tenants.sls" << 'EOF'
# #DigitalHabitat Tenants / Circles

digital_habitat:
  tenants: []
EOF

# ENV Pillars
cat > "${PILLAR_ROOT}/env/dev/settings.sls" << 'EOF'
# DEV-ENV spezifische Einstellungen

env: dev
EOF

cat > "${PILLAR_ROOT}/env/prod/settings.sls" << 'EOF'
# PROD-ENV spezifische Einstellungen

env: prod
EOF

# Secrets README (Hinweis auf Vault/sops)
cat > "${PILLAR_ROOT}/secrets/README.md" << 'EOF'
# Secrets / Vault-Integration

Hier KEINE Klartext-Keys oder Passwörter ablegen.

Empfehlungen:
- HashiCorp Vault (ext_pillar: vault)
- sops-verschlüsselte Pillars (per GPG/age)
EOF

echo
echo ">>> Struktur wurde erzeugt."
echo "   - States unter ${SALT_ROOT}"
echo "   - Pillars unter ${PILLAR_ROOT}"
echo
echo "Hinweis:"
echo "  * Passe /etc/salt/master (file_roots, pillar_roots, env_order) an diese Struktur an."
echo "  * Binde dein Git-Repo (sxplr-salt-repo) per GitFS oder direkt an /srv/salt."
