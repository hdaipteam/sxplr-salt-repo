# srv/pillar/base/global/settings.sls
# Globale SXPLR-Settings (Git, WireGuard, Salt-Defaults)

sxplr:
  git:
    repo_url: "git@github.com:hdaipteam/sxplr-salt-repo.git"
    branch: "main"
    path: "/opt/sxplr-salt-repo"

  wireguard:
    iface: "wg0"
    network: "10.99.0.0/24"

  salt:
    master:
      pub_port: 4505
      ret_port: 4506
      