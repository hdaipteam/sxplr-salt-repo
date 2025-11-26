# srv/pillar/base/mngm/mngm-002.sls
# Pillar für MNGM-002 (VPS: vps-a6f04377)

salt_master:
  id: "mngm-002.minion.saltvpn.cfg"
  hostname: "vps-a6f04377"
  role: "salt-master"
  wg_ip: "10.99.0.251"

  file_roots:
    base:
      - /srv/salt/base
    prod:
      - /srv/salt/prod

  pillar_roots:
    base:
      - /srv/pillar/base
    prod:
      - /srv/pillar/prod

  env_order:
    - base
    - prod
