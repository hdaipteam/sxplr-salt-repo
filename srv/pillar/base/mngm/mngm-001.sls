# srv/pillar/base/mngm/mngm-001.sls
# Pillar für MNGM-001 (VBOX: sxplr-grndctrl-ops-node-001)

salt_master:
  id: "mngm-001.minion.saltvpn.cfg"
  hostname: "sxplr-grndctrl-ops-node-001"
  role: "salt-master"
  wg_ip: "10.99.0.250"

  file_roots:
    base:
      - /srv/salt/base
    prod:
      - /srv/salt/prod
    dev:
      - /srv/salt/dev

  pillar_roots:
    base:
      - /srv/pillar/base
    prod:
      - /srv/pillar/prod
    dev:
      - /srv/pillar/dev

  env_order:
    - base
    - prod
    - dev
