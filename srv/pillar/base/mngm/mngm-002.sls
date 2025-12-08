# srv/pillar/base/mngm/mngm-002.sls
# Pillar für MNGM-002 (VPS: vps-a6f04377)

sxplr:
  env: prod
  role:
    type: management-master
    ha_role: primary             # MNGM-002 als "primary"
    cluster: sxplr-mngm-ha-cluster
  mngm:
    node_id: mngm-002.minion.saltvpn.cfg
    hostname: vps-a6f04377
    location: HDaIP Virtual Data Center OVH

salt_master:
  id: "mngm-002.minion.saltvpn.cfg"
  hostname: "vps-a6f04377"
  role: "salt-master"
  wg_ip: "10.99.0.251"

  ha:
    peer_id: "mngm-001.minion.saltvpn.cfg"
    peer_wg_ip: "10.99.0.250"

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

keepalived:
  enable: true
  interface: wg0
  virtual_ip: 10.99.0.10/32
  vrrp_instance: VI_SXPLR_SALT
  virtual_router_id: 42
  state: BACKUP          # MNGM-002 übernimmt nur im Failover
  priority: 150
