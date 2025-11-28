# srv/pillar/base/global/settings.sls
# Globale SXPLR-Settings (Git, WireGuard, Salt-Defaults)

sxplr:
  env: base
  role: generic
  description: "Globale Einstellungen für SXPLR-Umgebungen"

  salt:
    master:
      pub_port: 4505
      ret_port: 4506
  
  git:
    repo_url: "git@github.com:hdaipteam/sxplr-salt-repo.git"
    branch: "main"
    path: "/opt/sxplr-salt-repo"

  wireguard:
    iface: "wg0"
    network: "10.99.0.0/24"

  ha:
    masters:
      mngm-001.minion.saltvpn.cfg:
        peer_id: mngm-002.minion.saltvpn.cfg
        peer_ip: 10.99.0.251
      mngm-002.minion.saltvpn.cfg:
        peer_id: mngm-001.minion.saltvpn.cfg
        peer_ip: 10.99.0.250
      