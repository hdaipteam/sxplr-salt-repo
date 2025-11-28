# srv/salt/base/infra/salt/minion/init.sls
# Entry-Point für Minion-spezifische Konfiguration (auf MNGM-001/002)

include:
  - infra.salt.minion.grains
  - infra.salt.minion.systemd
