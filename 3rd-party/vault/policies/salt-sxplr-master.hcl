# /root/policies/saltstack-master.hcl
# Globale Policy fuer den Salt-Master-AppRole
# Vault-Policy-Name: "saltstack/master"

# --- KV v2: Salt-Daten lesen (z.B. globale SXPLR-Config) ---

path "salt/data/sxplr" {
  capabilities = ["read", "list"]
}

path "salt/data/sxplr/*" {
  capabilities = ["read", "list"]
}

path "salt/metadata/sxplr" {
  capabilities = ["read", "list"]
}

path "salt/metadata/sxplr/*" {
  capabilities = ["read", "list"]
}

path "salt/" {
  capabilities = ["read", "list"]
}

# Preflight / UI-Mount-Checks
path "sys/internal/ui/mounts" {
  capabilities = ["read", "list"]
}

path "sys/internal/ui/mounts/*" {
  capabilities = ["read", "list"]
}

# --- Token-Erzeugung fuer Minions erlauben ---

# Allgemeine Token-Erzeugung
path "auth/token/create" {
  capabilities = ["create", "update", "sudo"]
}

path "auth/token/create/*" {
  capabilities = ["create", "update", "sudo"]
}

# Lookup / Renew-self fuer den vom AppRole erhaltenen Token
path "auth/token/lookup-self" {
  capabilities = ["read"]
}

path "auth/token/renew-self" {
  capabilities = ["update"]
}

