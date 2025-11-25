# srv/salt/base/top.sls
# Globale Zuweisung von States für alle Minions (Basislayer)

base:
  '*':
    - infra.proxmox.base
    - infra.network.base
    - infra.security.ssh
