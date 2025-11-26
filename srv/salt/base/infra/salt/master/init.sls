# srv/salt/base/infra/salt/master/init.sls
# Entry-Point für das komplette Master-Bundle

include:
  - infra.salt.master.git
  - infra.salt.master.hardening
  - infra.salt.master.wireguard
  - infra.salt.master.config
  - infra.salt.master.systemd
