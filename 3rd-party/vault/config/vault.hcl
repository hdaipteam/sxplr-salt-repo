# /data/vault/config/vault.hcl
ui = true
log_level    = "info"
disable_mlock = true   # in Docker fast immer sinnvoll

api_addr     = "http://10.99.0.1:8200"
cluster_addr = "http://10.99.0.1:8201"
cluster_name = "sxplr-vault-cluster"

listener "tcp" {
  address     = "0.0.0.0:8200"  # hört im Docker-Netz & via Host-Mapping
  tls_disable = 1               # ok im WG-Mesh; später TLS aktivieren
}

storage "file" {
  path = "/vault/file"
}
