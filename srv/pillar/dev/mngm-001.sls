keepalived:
  enable: true
  interface: wg0
  virtual_ip: 10.99.0.10/32
  vrrp_instance: VI_SXPLR_SALT
  virtual_router_id: 42
  state: MASTER        # auf MNGM-001
  priority: 200
