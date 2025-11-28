# srv/salt/base/infra/salt/minion/init.sls
# Entry-Point für das komplette Minion-Bundle

include:
  - infra.salt.minion.init
  - infra.salt.minion.systemd
  - infra.salt.minion.grains