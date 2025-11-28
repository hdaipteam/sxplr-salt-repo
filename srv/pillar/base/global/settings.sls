# srv/pillar/base/global/settings.sls
# Globale SXPLR-Settings (git, wireguard, ports, HA-Mapping etc.)

sxplr:
  description: "SXPLR SaltStack Management Cluster"
  git:
    repo_url: git@github.com:hdaipteam/sxplr-salt-repo.git
    path: /opt/sxplr-salt-repo
    branch: main

  salt:
    master:
      pub_port: 4505
      ret_port: 4506

  wireguard:
    iface: wg0
    network: 10.99.0.0/24

  ha:
    masters:
      mngm-001.minion.saltvpn.cfg:
        peer_id: mngm-002.minion.saltvpn.cfg
        peer_ip: 10.99.0.251
      mngm-002.minion.saltvpn.cfg:
        peer_id: mngm-001.minion.saltvpn.cfg
        peer_ip: 10.99.0.250

      