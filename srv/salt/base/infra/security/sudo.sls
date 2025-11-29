# srv/salt/base/infra/security/sudo.sls
{%- set sudo_cfg = pillar.get('security', {}).get('sudo', {}) %}
{%- if sudo_cfg.get('cloudmaster_nopasswd', False) %}

cloudmaster-sudo-nopasswd:
  file.managed:
    - name: /etc/sudoers.d/cloudmaster
    - mode: "0440"
    - user: root
    - group: root
    - contents: |
        cloudmaster ALL=(ALL) NOPASSWD:ALL

{%- endif %}
