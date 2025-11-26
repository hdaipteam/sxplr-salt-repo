{% set wg_unit = 'wg-quick@wg0.service' %}

/etc/systemd/system/salt-minion.service.d/override.conf:
  file.managed:
    - makedirs: True
    - mode: "0644"
    - contents: |
        [Unit]
        After=network-online.target {{ wg_unit }}
        Wants=network-online.target {{ wg_unit }}

salt-minion-systemd-daemon-reload:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: /etc/systemd/system/salt-minion.service.d/override.conf

salt-minion-service:
  service.running:
    - name: salt-minion
    - enable: True
    - require:
      - cmd: salt-minion-systemd-daemon-reload
