# # srv/salt/base/infra/salt/minion/systemd.sls
# # Systemd-Overrides für normale Minions
# # (Master-Minions bekommen eigene Overrides im Master-Bundle)

# {% set wg_unit = "wg-quick@wg0.service" %}

# salt-minion-systemd-override:
#   file.managed:
#     - name: /etc/systemd/system/salt-minion.service.d/override.conf
#     - makedirs: true
#     - mode: "0644"
#     - user: root
#     - group: root
#     - contents: |
#         [Unit]
#         After=network-online.target {{ wg_unit }}
#         Wants=network-online.target {{ wg_unit }}

# salt-minion-daemon-reload:
#   cmd.run:
#     - name: systemctl daemon-reload
#     - onchanges:
#       - file: salt-minion-systemd-override

# salt-minion-service-running-main:
#   service.running:
#     - name: salt-minion
#     - enable: true
#     - require:
#       - cmd: salt-minion-daemon-reload

# srv/salt/base/infra/salt/minion/systemd.sls
# Systemd-Overrides für normale Minions
# (Master-Minions bekommen eigene Overrides im Master-Bundle)

{%- set sxplr = pillar.get('sxplr', {}) %}
{%- set wg_iface = sxplr.get('wireguard', {}).get('iface', 'wg0') %}
{%- set wg_unit = 'wg-quick@' ~ wg_iface ~ '.service' %}

salt-minion-systemd-override:
  file.managed:
    - name: /etc/systemd/system/salt-minion.service.d/override.conf
    - makedirs: true
    - mode: "0644"
    - user: root
    - group: root
    - contents: |
        [Unit]
        After=network-online.target {{ wg_unit }}
        Wants=network-online.target {{ wg_unit }}

salt-minion-daemon-reload:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: salt-minion-systemd-override

salt-minion-service-running-main:
  service.running:
    - name: salt-minion
    - enable: true
    - require:
      - cmd: salt-minion-daemon-reload
