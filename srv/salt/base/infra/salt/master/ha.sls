# srv/salt/base/infra/salt/master/ha.sls

{%- set repo_path = salt['pillar.get']('sxplr:git:path', '/opt/sxplr-salt-repo') %}
{%- set ha_role = salt['grains.get']('sxplr_role:ha_role', 'single') %}
{%- set peer_id = salt['grains.get']('salt_master:ha_peer_id', '') %}
{%- set peer_wg_ip = salt['grains.get']('salt_master:ha_peer_wg_ip', '') %}

ha-check-script:
  file.managed:
    - name: /usr/local/sbin/check_salt_master.sh
    - source: salt://infra/salt/master/files/check_salt_master.sh.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: "0750"
    - context:
        repo_path: {{ repo_path }}
        ha_role: {{ ha_role }}
        peer_id: {{ peer_id }}
        peer_wg_ip: {{ peer_wg_ip }}

ha-service-unit:
  file.managed:
    - name: /etc/systemd/system/salt-master-ha.service
    - source: salt://infra/salt/master/files/salt-master-ha.service.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: "0644"
  watch_in:
    - cmd: systemd-reload-ha

ha-timer-unit:
  file.managed:
    - name: /etc/systemd/system/salt-master-ha.timer
    - source: salt://infra/salt/master/files/salt-master-ha.timer.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: "0644"
  watch_in:
    - cmd: systemd-reload-ha

systemd-reload-ha:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: ha-service-unit
      - file: ha-timer-unit

ha-timer-enabled:
  service.enabled:
    - name: salt-master-ha.timer
    - require:
      - file: ha-timer-unit

ha-timer-running:
  service.running:
    - name: salt-master-ha.timer
    - enable: True
    - require:
      - service: ha-timer-enabled

