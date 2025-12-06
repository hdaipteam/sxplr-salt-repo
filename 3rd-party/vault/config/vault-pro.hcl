# /data/vault/config/vault.hcl
# ======================================================================
# SXPLR Vault – produktionsnahe Konfiguration (Single Node, File Backend)
# Host: GRNDCTRL (Notebook)
# Erreichbar für Salt-Master: 10.99.0.1:8200 (über WireGuard wg0)
# ======================================================================

# UI aktivieren (wichtig für Verwaltung & Debugging)
ui = true

# -------------------------
# Listener-Konfiguration
# -------------------------
# Listener auf allen Interfaces im Container.
# TLS ist im WG-Mesh vorerst deaktiviert (tls_disable = 1).
# Später kannst du hier auf TLS umstellen.
listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1
  # Für TLS später z.B.:
  # tls_disable = 0
  # tls_cert_file = "/vault/certs/fullchain.pem"
  # tls_key_file  = "/vault/certs/privkey.pem"
}

# -------------------------
# Storage Backend
# -------------------------
# File Storage – durch Docker-Volume auf Host persistiert
storage "file" {
  path = "/vault/file"
}

# -------------------------
# API- & Cluster-Adresse
# -------------------------
# WICHTIG: Diese Adressen sind das, was Vault den Clients zurückmeldet.
# => Muss zur Sicht der Salt-Master passen.
# Salt-Master erreichen Vault über 10.99.0.1:8200 (wg0 auf GRNDCTRL).
api_addr     = "http://10.99.0.1:8200"
cluster_addr = "http://10.99.0.1:8201"

# -------------------------
# Performance & Sicherheit
# -------------------------

# mlock aktiv lassen (verhindert Swapping von Secrets).
# Im offiziellen Vault-Image ist CAP_IPC_LOCK normalerweise gesetzt.
disable_mlock = false

# Log-Level "info" für Betrieb, "debug" nur temporär zum Analysieren
log_level = "info"

# Optional: eigener Cluster-Name (nützlich, falls später HA/Raft)
cluster_name = "sxplr-vault-cluster"

# -------------------------
# Audit Logging
# -------------------------
# Audit-Logs sind für ein produktives Setup Pflicht.
# Pfad muss per Docker-Volume auf Host gemappt sein, z.B. /data/vault/audit
# Host-Verzeichnis: Besitzer root, Modus 0750 oder 0700
audit "file" {
  path = "/vault/audit/audit.log"
  mode = "0640"
}

# -------------------------
# Telemetry (optional, zum Monitoring)
# -------------------------
# Kann später an Prometheus/Statsd angebunden werden.
# telemetry {
#   disable_hostname = true
#   prometheus_retention_time = "30s"
# }

