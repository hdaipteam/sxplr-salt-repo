# /srv/pillar/base/mngm/mngm-001.sls
# Pillar für MNGM-001 (VBOX: sxplr-grndctrl-ops-node-001)

sxplr:
  env: dev
  role:
    type: management-master
    ha_role: secondary          # MNGM-001 als "secondary"
    cluster: sxplr-mngm-ha-cluster
  mngm:
    node_id: mngm-001.minion.saltvpn.cfg
    hostname: sxplr-grndctrl-ops-node-001
    location: HDaIP Virtual Data Center OVH

salt_master:
  id: "mngm-001.minion.saltvpn.cfg"
  hostname: "sxplr-grndctrl-ops-node-001"
  role: "salt-master"
  wg_ip: "10.99.0.250"

  ha:
    peer_id: "mngm-002.minion.saltvpn.cfg"
    peer_wg_ip: "10.99.0.251"

  # Target: /etc/salt/master.d/roots.conf
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

keepalived:
  enable: true
  interface: wg0
  virtual_ip: 10.99.0.10/32
  vrrp_instance: VI_SXPLR_SALT
  virtual_router_id: 42
  state: MASTER          # MNGM-001 hält die VIP im Normalfall
  priority: 200