# srv/salt/base/infra/security/ssh.sls
# Basis-SSH-Hardening für alle SXPLR-Hosts

{%- set ssh_port = salt['pillar.get']('security:ssh:port', 22) %}
{%- set permit_root = salt['pillar.get']('security:ssh:permit_root', 'no') %}
{%- set password_auth = salt['pillar.get']('security:ssh:password_auth', 'no') %}

/etc/ssh/sshd_config:
  file.managed:
    - source: salt://infra/security/files/sshd_config.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: "0600"
    - backup: minion
    - context:
        ssh_port: {{ ssh_port }}
        permit_root: {{ permit_root }}
        password_auth: {{ password_auth }}

sshd:
  service.running:
    - name: ssh
    - enable: True
    - reload: True
    - watch:
      - file: /etc/ssh/sshd_config

