# srv/salt/base/infra/salt/master/init.sls
# Entry-Point für das komplette Master-Bundle

include:
  - infra.salt.master.config
  - infra.salt.master.systemd
  - infra.security.ssh   # falls du ssh-harden hier mitziehen willst
