# srv/salt/base/infra/proxmox/base.sls
# Basis-Config für Proxmox VE-Knoten

include:
  - infra.security.ssh

base-packages:
  pkg.installed:
    - pkgs:
      - htop
      - jq
      - vim
      - net-tools
      - curl

pve-ssh-service:
  service.running:
    - name: ssh
    - enable: true
