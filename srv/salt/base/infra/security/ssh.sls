# srv/salt/base/infra/security/ssh.sls
# Basis-SSH-Hardening für alle SXPLR-Hosts
# Managed by Salt - DO NOT EDIT MANUALLY

{%- set ssh_port_raw      = salt['pillar.get']('security:ssh:port', 22) %}
{%- set permit_root_raw   = salt['pillar.get']('security:ssh:permit_root', 'prohibit-password') %}
{%- set password_auth_raw = salt['pillar.get']('security:ssh:password_auth', 'no') %}

{# Wir reichen die Rohwerte in den Kontext durch.
   Die eigentliche Normalisierung passiert in der Jinja-Template-Datei. #}
{%- set ssh_port      = ssh_port_raw %}
{%- set permit_root   = permit_root_raw %}
{%- set password_auth = password_auth_raw %}

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


