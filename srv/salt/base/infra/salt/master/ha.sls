# srv/salt/base/infra/salt/master/ha.sls
# HA- und Self-Heal-Mechanismen für MNGM-001 und MNGM-002

{%- set repo_path = salt['pillar.get']('sxplr:git:path', '/opt/sxplr-salt-repo') %}

ha_check_script:
  file.managed:
    - name: /usr/local/sbin/check_salt_master.sh
    - source: salt://infra/salt/master/files/check_salt_master.sh.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: "0750"

ha_service_unit_file:
  file.managed:
    - name: /etc/systemd/system/salt-master-ha.service
    - source: salt://infra/salt/master/files/salt-master-ha.service.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: "0644"

ha_timer_unit_file:
  file.managed:
    - name: /etc/systemd/system/salt-master-ha.timer
    - source: salt://infra/salt/master/files/salt-master-ha.timer.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: "0644"

ha_systemd_daemon_reload:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: ha_service_unit_file
      - file: ha_timer_unit_file

ha_timer_enabled:
  service.enabled:
    - name: salt-master-ha.timer
    - require:
      - cmd: ha_systemd_daemon_reload

ha_timer_running:
  service.running:
    - name: salt-master-ha.timer
    - enable: True
    - require:
      - service: ha_timer_enabled
