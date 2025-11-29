# srv/salt/base/infra/salt/master/systemd.sls
# systemd-Units für Salt-Master + Self-Managing Minion
# inklusive WireGuard-Abhängigkeit

{% set wg_iface = pillar.get("sxplr", {}).get("wireguard", {}).get("iface", "wg0") %}

# --- MASTER SERVICE OVERRIDES ---

salt-master-systemd-dir:
  file.directory:
    - name: /etc/systemd/system/salt-master.service.d
    - user: root
    - group: root
    - mode: "0755"

salt-master-wireguard-dropin:
  file.managed:
    - name: /etc/systemd/system/salt-master.service.d/10-wireguard.conf
    - user: root
    - group: root
    - mode: "0644"
    - contents: |
        [Unit]
        After=wg-quick@{{ wg_iface }}.service
        Wants=wg-quick@{{ wg_iface }}.service

# --- SELF-MANAGING MASTER: MINION OVERRIDES ---

salt-master-minion-systemd-dir:
  file.directory:
    - name: /etc/systemd/system/salt-minion.service.d
    - user: root
    - group: root
    - mode: "0755"

salt-master-minion-wireguard-dropin:
  file.managed:
    - name: /etc/systemd/system/salt-minion.service.d/10-wireguard.conf
    - user: root
    - group: root
    - mode: "0644"
    - contents: |
        [Unit]
        After=wg-quick@{{ wg_iface }}.service
        Wants=wg-quick@{{ wg_iface }}.service

salt-master-systemd-daemon-reload:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: salt-master-wireguard-dropin
      - file: salt-master-minion-wireguard-dropin

salt-master-service-running:
  service.running:
    - name: salt-master
    - enable: true
    - require:
      - cmd: salt-master-systemd-daemon-reload

salt-master-minion-service-running:
  service.running:
    - name: salt-minion
    - enable: true
    - require:
      - cmd: salt-master-systemd-daemon-reload
