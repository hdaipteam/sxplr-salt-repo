# /root/policies/saltstack-minions.hcl
# Globale Policy fuer alle Salt-Minion-Tokens
# Vault-Policy-Name: "saltstack/minions"

# --- KV v2: Daten unter Mount "salt" im Namespace sxplr ---

# Daten-Pfade
path "salt/data/sxplr" {
  capabilities = ["read", "list"]
}

path "salt/data/sxplr/*" {
  capabilities = ["read", "list"]
}

# Metadaten-Pfade (Versionen etc.)
path "salt/metadata/sxplr" {
  capabilities = ["read", "list"]
}

path "salt/metadata/sxplr/*" {
  capabilities = ["read", "list"]
}

# Root des KV-Mounts, damit "list" etc. funktioniert
path "salt/" {
  capabilities = ["read", "list"]
}

# --- Preflight / UI-Mount-Checks generisch erlauben ---

# Salt/hvac ruft sys/internal/ui/mounts/<irgendwas> auf (z.B. "salt", "sxplr/test", ...)
path "sys/internal/ui/mounts" {
  capabilities = ["read", "list"]
}

path "sys/internal/ui/mounts/*" {
  capabilities = ["read", "list"]
}

