# srv/salt/base/infra/salt/master/init.sls
# Entry-Point für das komplette Master-Bundle

include:
  - infra.salt.master.git         # Git-Repository für Salt-Dateien
  - infra.salt.master.hardening   # Basishärtung des Masters
  - infra.salt.master.wireguard   # WireGuard-Setup für Salt-Master
  - infra.salt.master.config      # salt-master.conf, etc.
  - infra.salt.master.systemd     # systemd-Units für Salt-Master
  - infra.salt.master.grains      # Grains für Salt-Master
  - infra.salt.master.ha          # gegenseitige Absicherung / HA-Healthcheck