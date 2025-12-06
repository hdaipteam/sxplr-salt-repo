keepalived:
  enable: true
  interface: wg0
  virtual_ip: 10.99.0.10/32
  vrrp_instance: VI_SXPLR_SALT
  virtual_router_id: 42
  state: BACKUP        # auf MNGM-002
  priority: 150
