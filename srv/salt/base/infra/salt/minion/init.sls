# srv/salt/base/infra/salt/minion/init.sls
# Entry-Point für Minion-spezifische States

include:
  - infra.salt.minion.config
  - infra.salt.minion.systemd
  - infra.salt.minion.grains

