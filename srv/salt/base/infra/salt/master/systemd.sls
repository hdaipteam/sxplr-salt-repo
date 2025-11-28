
# srv/salt/base/infra/salt/master/systemd.sls
# systemd-Units für salt-master und salt-minion, abhängig von WireGuard

{%- set wg_iface = pillar.get("sxplr", {}).get("wireguard", {}).get("iface", "wg0") %}

# Drop-in für Salt Master
/etc/systemd/system/salt-master.service.d:
  file.directory:
    - user: root
    - group: root
    - mode: "0755"

/etc/systemd/system/salt-master.service.d/10-wireguard.conf:
  file.managed:
    - user: root
    - group: root
    - mode: "0644"
    - contents: |
        [Unit]
        After=wg-quick@{{ wg_iface }}.service
        Wants=wg-quick@{{ wg_iface }}.service

# Drop-in für Salt Minion (Self-Managing Master)
/etc/systemd/system/salt-minion.service.d:
  file.directory:
    - user: root
    - group: root
    - mode: "0755"

/etc/systemd/system/salt-minion.service.d/10-wireguard.conf:
  file.managed:
    - user: root
    - group: root
    - mode: "0644"
    - contents: |
        [Unit]
        After=wg-quick@{{ wg_iface }}.service
        Wants=wg-quick@{{ wg_iface }}.service

systemd-reload:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: /etc/systemd/system/salt-master.service.d/10-wireguard.conf
      - file: /etc/systemd/system/salt-minion.service.d/10-wireguard.conf

salt-master-service:
  service.running:
    - name: salt-master
    - enable: true
    - require:
      - cmd: systemd-reload

salt-minion-service:
  service.running:
    - name: salt-minion
    - enable: true
    - require:
      - cmd: systemd-reload
