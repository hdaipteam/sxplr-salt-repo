# srv/salt/base/infra/security/users_audit.sls
# Audit für Admin-User (cloudmaster) und optionale Migration ubuntu -> cloudmaster

{%- set ssh_cfg = pillar.get('security', {}).get('ssh', {}) %}
{%- set users = ssh_cfg.get('users', {}) %}
{%- set migrate_flag = ssh_cfg.get('migrate_ubuntu_to_cloudmaster', False) %}

{# ---------------------------------------------------------
   1. Audit: cloudmaster existiert und ist sudoer
   --------------------------------------------------------- #}

{%- set cm_cfg = users.get('cloudmaster', {}) %}
{%- if cm_cfg.get('enabled', False) %}

{%- set cm_info = salt['user.info']('cloudmaster') %}

{%- if cm_info and cm_info.get('name') %}
cloudmaster-audit-exists:
  test.succeed_without_changes:
    - name: "cloudmaster existiert (uid={{ cm_info.get('uid') }}, gid={{ cm_info.get('gid') }})."
{%- else %}
cloudmaster-audit-missing:
  test.fail_without_changes:
    - name: "cloudmaster ist NICHT vorhanden – Standard-Admin-Account fehlt."
{%- endif %}

{%- if cm_info and cm_info.get('name') %}
{%- set cm_groups = cm_info.get('groups', []) %}
{%- if 'sudo' in cm_groups %}
cloudmaster-audit-sudo:
  test.succeed_without_changes:
    - name: "cloudmaster ist Mitglied der Gruppe 'sudo' (sudo -i => root möglich)."
{%- else %}
cloudmaster-audit-sudo-missing:
  test.fail_without_changes:
    - name: "cloudmaster ist NICHT Mitglied der Gruppe 'sudo' – sudo -i funktioniert nicht."
{%- endif %}
{%- endif %}
{%- endif %}

{# ---------------------------------------------------------
   2. Audit: Migration ubuntu -> cloudmaster
   --------------------------------------------------------- #}

{%- if migrate_flag %}
{%- set ub_info = salt['user.info']('ubuntu') %}

{%- if ub_info and ub_info.get('name') %}
{%- set ub_groups = ub_info.get('groups', []) %}
{%- set ubuntu_ssh_keys = salt['file.file_exists']('/home/ubuntu/.ssh/authorized_keys') %}

ubuntu-audit-no-sudo:
  {%- if 'sudo' in ub_groups %}
  test.fail_without_changes:
    - name: "ubuntu ist noch in der Gruppe 'sudo' – Migration nicht vollständig."
  {%- else %}
  test.succeed_without_changes:
    - name: "ubuntu ist NICHT in der Gruppe 'sudo' – OK (Rechte migriert)."
  {%- endif %}

ubuntu-audit-no-ssh-keys:
  {%- if ubuntu_ssh_keys %}
  test.fail_without_changes:
    - name: "ubuntu hat noch /home/ubuntu/.ssh/authorized_keys – SSH-Login noch möglich."
  {%- else %}
  test.succeed_without_changes:
    - name: "ubuntu hat keine authorized_keys – SSH-Login effektiv deaktiviert."
  {%- endif %}
{%- else %}
ubuntu-audit-no-user:
  test.succeed_without_changes:
    - name: "ubuntu-User existiert nicht – nichts zu migrieren."
{%- endif %}
{%- endif %}
