# 🌐 sxplr-salt-repo – Decentralized Autonomous Ecosystem (DAE) Infrastruktur-Code

> **Infrastructure-as-Code (IaC) für echte Peer-to-Peer-Autonomie, Circle-Topologien & Compliance-by-Design**

[![Status](https://img.shields.io/badge/Status-v0.5.2%20DRAFT-orange)]()
[![License](https://img.shields.io/badge/Lizenz-CC%20BY--SA%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-sa/4.0/)
[![Orchestrierung](https://img.shields.io/badge/Orchestrierung-SaltStack%20%2B%20GitFS-green)]()
[![Architektur](https://img.shields.io/badge/DAE-Architektur-Positionspapier%20%26%20Whitepaper-blue)]()

---

## 📖 Überblick & Vision

Dieses Repository operationalisiert die im **Positionspapier** (`DAE-PP-2026-001-v0.5.1`) und im **Whitepaper** (`DAE-WP-2026-001-v0.5.2`) beschriebene Infrastruktur des Decentralized Autonomous Ecosystems (DAE) als vollständig automatisierten, versionierten und auditierbaren SaltStack-Code.

Ziel ist die Bereitstellung einer **produktionsreifen, souveränen Netzwerkinfrastruktur**, die:
- 🔹 Zentrale Vermittler auf OSI-Layer 2–4 eliminiert
- 🔹 Circle-basierte Peering-Beziehungen & 1:1 Sibling-Paarung automatisiert
- 🔹 TPM 2.0 als Hardware-Root-of-Trust für alle kritischen Operationen erzwingt
- 🔹 Zero-Trust-Container, lokale Datenpersistenz & selective Disclosure standardisiert
- 🔹 Autonome Self-Healing-Logik & GitOps-Konvergenz implementiert

Das DAE ist keine alternative Plattform, sondern die **infrastrukturelle Wiederherstellung von Eigentum, Privatsphäre und authentischer Zusammenarbeit** im digitalen Raum.

---

## 🧩 Architektur-Prinzipien

| Prinzip | Technische Umsetzung im Repository |
|---------|-----------------------------------|
| **Echtes P2P** | `B.A.T.M.A.N. advanced` (L2), `WireGuard` (L3), `p2plib` (L5–7) |
| **Circle-Topologie** | Explizite Autorisierung, Circle-scoped Pillars, Multi-Sign-Validierung |
| **Hardware-Root-of-Trust** | TPM 2.0 Sealing/Unsealing, PCR-Binding, `tpm2-tools` Integration |
| **GitOps & Autonomie** | `gitfs`-Backend, deklarative States, automatische Drift-Erkennung |
| **Compliance-by-Design** | Lokale NVMe-Persistenz, `metadata_first_indexing`, Audit-Hashing |
| **Zero-Trust Runtime** | Non-root Container, Read-only FS, Seccomp/AppArmor, isolierte Netzwerke |

---

## 📁 Repository-Struktur

```
sxplr-salt-repo/
├── pillar/                 # Circle- & Node-spezifische Konfigurationen
│   ├── circles/            # Circle-Regeln, Peering-ACLs, Governance-Policies
│   └── nodes/              # Hardware-IDs, WireGuard-IPs, TPM-Handles, Service-Flags
├── states/                 # DAE-Infrastruktur-Definitionen
│   ├── base/               # OS-Hardening, Kernel-Module, Salt-Minion-Setup
│   ├── network/            # B.A.T.M.A.N., WireGuard, p2plib-Daemon, Caddy-Proxy
│   ├── dae-core/           # Circle-Auth, CRDT-Sync, Selective Disclosure, TPM-Sealing
│   ├── containers/         # Docker/Podman, Zero-Trust-Profiles, Volume-Mounts
│   └── monitoring/         # PLG-Stack (Prometheus/Loki/Grafana), Salt-Scheduler
├── templates/              # Jinja2-Vorlagen für Konfig-Files & Circle-Regeln
├── scripts/                # `cs-wizard.py`, Schema-Validator, TPM-Attestation-Checks
├── terraform/              # (Optional) OVH Kimsufi / VPS Gateway-Provisionierung
├── docs/                   # Architektur-Diagramme, Deployment-Guides, Audit-Reports
└── README.md
```

---

## ⚙️ Voraussetzungen & Hardware

| Komponente | Empfehlung | Hinweis |
|------------|------------|---------|
| **CPU/RAM** | ≥4 Cores, ≥8 GB RAM | Für `batman-adv`, `wireguard`, Container-Runtime & CRDT-Caches |
| **Speicher** | 2× NVMe SSD (OS + Data) | OPAL 2.0 Hardware-Verschlüsselung empfohlen |
| **Security** | TPM 2.0 Chip | Intel PTT, AMD fTPM oder diskreter Chip (ISO/IEC 11889:2015) |
| **OS** | Debian 12 / DietPi Bookworm | Minimal-Installation, Kernel ≥ 4.12 |
| **Netzwerk** | Gigabit-Ethernet + optional WLAN | Dual-NIC oder VLAN-fähiger Switch für Mesh/Service-Trennung |

---

## 🚀 Bereitstellung (Provisioning)

### 1. Basis-System vorbereiten
```bash
# TPM-Tools & Salt Minion installieren
sudo apt update && sudo apt install -y tpm2-tools salt-minion git

# GitFS für Salt konfigurieren
sudo mkdir -p /etc/salt/minion.d
cat <<EOF | sudo tee /etc/salt/minion.d/gitfs.conf
fileserver_backend:
  - gitfs
gitfs_remotes:
  - git@github.com:hdaipteam/sxplr-salt-repo.git
gitfs_provider: pygit2
gitfs_base: main
gitfs_root: states/
pillar_roots:
  base:
    - /srv/pillar
    - gitfs://pillar/
EOF
```

### 2. Circle & Node generieren
```bash
chmod +x scripts/cs-wizard.py
./scripts/cs-wizard.py
# → Erstellt automatisch pillar/nodes/<pair>-<role>.yaml
# → Commit & Push via interaktiver Abfrage
```

### 3. Infrastruktur konvergieren
```bash
# State anwenden (manuell)
sudo salt-call state.apply

# Oder warten auf automatische Konvergenz (alle 15 Min via Scheduler)
```

### 4. Verifikation
```bash
# TPM-Sealing prüfen
tpm2_pcrread sha256:0,1,4,7,10

# Netzwerk-Status
batctl o
wg show

# CRDT-Sync & Circle-Auth
journalctl -u p2plib.service -f
```

---

## 🔐 Sicherheit & Compliance

| Aspekt | Umsetzung im DAE-Code |
|--------|----------------------|
| **TPM-Sealing** | Keys verlassen niemals den Chip; `tpm2_unseal` nur bei validen PCRs |
| **Zero-Trust Container** | `USER 1000:1000`, `read_only: true`, Seccomp-Profile, kein `privileged` |
| **Datenschutz (DSGVO)** | Lokale Persistenz, keine zentrale Logs, `metadata_first_indexing: true` |
| **Auditierbarkeit** | Git-Historie + TPM-Quotes + Hash-Anchoring (`sha256(log_chunk)`) |
| **Selective Disclosure** | Granulare Export-Modes: `metadata_only`, `payload_hash_only`, `full_frozen_snapshot` |

---

## 🛠️ Betrieb & Self-Healing

- **Drift-Detection:** Salt-Scheduler prüft alle 15 Minuten den Ist-/Soll-Zustand.
- **Auto-Rollback:** Bei Abweichung wird automatisch der letzte signierte Git-Commit angewendet.
- **Monitoring:** Lokaler PLG-Stack (Prometheus, Loki, Grafana); Zugriff nur via WireGuard.
- **Fallback:** Bei Node-Ausfall übernimmt der Sibling-Gateway; CRDT-Puffering garantiert Offline-First-Betrieb.
- **CI/CD Quality Gates:** `yamllint`, `salt-lint`, Schema-Validator & IP-Konflikt-Prüfung vor Merge.

---

## 📖 Weiterführende Dokumentation

| Dokument | Beschreibung |
|----------|--------------|
| 📘 **Positionspapier** `DAE-PP-2026-001-v0.5.1` | Gesellschaftlich-politische Begründung, Agnotologie-Resistenz, Circle-Prinzip |
| 📗 **Whitepaper** `DAE-WP-2026-001-v0.5.2` | Technische Spezifikation, Protokoll-Triade, TPM-Integration, GitOps-Betrieb |
| 🔧 **DAE-Auth-App Blueprint** | Mobile Authentifizierung basierend auf Corona-Warn-App-Architektur |
| 🌍 **Freifunk / FunkFeuer Integration** | Overlay-Szenarien, Gluon-Erweiterungen, Community-Mesh-Kompatibilität |

---

## 🤝 Mitwirken & Lizenz

- **Forks & Anpassungen:** Explizit erwünscht. Das DAE ist ein offenes, gemeinwohlorientiertes Infrastrukturprojekt.
- **Beiträge:** Bitte Pull Requests gegen `main` öffnen. Alle States/Pillars müssen `yamllint`/`salt-lint` bestehen.
- **Lizenz:** CC BY-SA 4.0 (außer vertrauliche Konzepte wie `#Patoshi`, siehe Whitepaper Kap. 12)
- **Haftungsausschluss:** Dieses Repository dient der Infrastrukturbereitstellung. Betreiber:innen tragen die volle Verantwortung für Circle-Governance, rechtliche Konformität und Betriebssicherheit.

---

## 📬 Kontakt

**Autor:** Ralf Siebert (aka Maxim R. Garrtner)  
📧 [maxim.r.garrtner@yandex.com](mailto:maxim.r.garrtner@yandex.com)  
🔗 **Verfügbare Artefakte auf Anfrage:** SaltStack-State-Templates, Docker-Compose-Bundle, Terraform-Module, `p2plib`-CRDT-Implementierung, Competence Signature Core.

> *„Dezentralität ist kein technisches Feature. Sie ist die Wiederherstellung von Eigentum, Privatsphäre und Kooperation im digitalen Raum."*  
> © 2026 Ralf Siebert. Veröffentlicht unter CC BY-SA 4.0. Basierend auf „Anatomie eines Peer to Peer Netzwerks“ (2023/2026) & aktueller Open-Source-Infrastruktur-Praxis. 🌐🔐
