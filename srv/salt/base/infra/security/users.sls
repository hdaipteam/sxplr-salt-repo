# srv/salt/base/infra/security/users.sls
# Robustes User-Management & SSH-Keys auf Basis der Pillars
# - ändert UID/GID nur, wenn es gefahrlos möglich ist
# - bricht nicht ab, wenn User bereits mit anderer UID existiert
# - optional: Migration des Ubuntu-Standard-Users "ubuntu" zu "cloudmaster"

{%- set ssh_cfg = pillar.get('security', {}).get('ssh', {}) %}
{%- set users = ssh_cfg.get('users', {}) %}

{# ---------------------------------------------------------
   1. Normale SSH-User aus security:ssh:users
   --------------------------------------------------------- #}

{%- for username, u in users.items() %}
{%-   if u.get('enabled', True) %}

{%-     set home = u.get('home', '/home/' ~ username) %}
{%-     set shell = u.get('shell', '/bin/bash') %}
{%-     set desired_uid = u.get('uid') %}
{%-     set desired_gid = u.get('gid') %}
{%-     set groups = u.get('groups', []) %}
{%-     set auth_keys = u.get('authorized_keys', []) %}
{%-     set allow_uid_change = u.get('allow_uid_change', False) %}
{%-     set allow_gid_change = u.get('allow_gid_change', False) %}

{# --- Bestehende User/Group-Infos vom System holen --- #}
{%-     set info = salt['user.info'](username) %}
{%-     set exists = info and info.get('name') %}
{%-     if exists %}
{%-       set existing_uid = info.get('uid') %}
{%-       set existing_gid = info.get('gid') %}
{%-     else %}
{%-       set existing_uid = None %}
{%-       set existing_gid = None %}
{%-     endif %}

{%-     set ginfo = salt['group.info'](username) %}
{%-     set group_exists = ginfo and ginfo.get('name') %}
{%-     if group_exists %}
{%-       set existing_group_gid = ginfo.get('gid') %}
{%-     else %}
{%-       set existing_group_gid = None %}
{%-     endif %}

{# ---------------------------------------------------------
   1a. Gruppe anlegen/prüfen
   --------------------------------------------------------- #}

{{ username }}-group:
  group.present:
    - name: {{ username }}
    {%- if desired_gid is not none %}
      {%- if not group_exists %}
    - gid: {{ desired_gid }}
      {%- elif existing_group_gid == desired_gid %}
    - gid: {{ desired_gid }}
      {%- elif allow_gid_change %}
    - gid: {{ desired_gid }}
      {%- endif %}
    {%- endif %}

{# ---------------------------------------------------------
   1b. User anlegen/prüfen (ohne harte UID-Zwangsänderung)
   --------------------------------------------------------- #}

{{ username }}-user:
  user.present:
    - name: {{ username }}
    - home: {{ home }}
    - shell: {{ shell }}
    - createhome: True
    {# UID nur setzen, wenn sicher oder explizit erlaubt #}
    {%- if desired_uid is not none %}
      {%- if not exists %}
    - uid: {{ desired_uid }}
      {%- elif existing_uid == desired_uid %}
    - uid: {{ desired_uid }}
      {%- elif allow_uid_change %}
    - uid: {{ desired_uid }}
    - allow_uid_change: True
      {%- endif %}
    {%- endif %}
    {# GID nur setzen, wenn Gruppe passt oder explizit erlaubt #}
    {%- if desired_gid is not none %}
      {%- if not exists %}
    - gid: {{ desired_gid }}
      {%- elif existing_gid == desired_gid %}
    - gid: {{ desired_gid }}
      {%- elif allow_gid_change %}
    - gid: {{ desired_gid }}
      {%- endif %}
    {%- else %}
    - gid: {{ username }}
    {%- endif %}
    {%- if groups %}
    - groups:
      {%- for g in groups %}
      - {{ g }}
      {%- endfor %}
    {%- endif %}
    - require:
      - group: {{ username }}-group

{# ---------------------------------------------------------
   1c. .ssh-Verzeichnis & authorized_keys
   --------------------------------------------------------- #}

{{ username }}-ssh-dir:
  file.directory:
    - name: {{ home }}/.ssh
    - user: {{ username }}
    - group: {{ username }}
    - mode: "0700"
    - makedirs: True
    - require:
      - user: {{ username }}-user

{%-     for key in auth_keys %}

{{ username }}-ssh-key-{{ loop.index }}:
  ssh_auth.present:
    - user: {{ username }}
    - name: {{ key }}
    - require:
      - file: {{ username }}-ssh-dir

{%-     endfor %}
{%-   endif %}
{%- endfor %}

{# ---------------------------------------------------------
   2. Migration ubuntu -> cloudmaster (optional via Pillar)
   --------------------------------------------------------- #}

{%- set migrate_flag = ssh_cfg.get('migrate_ubuntu_to_cloudmaster', False) %}
{%- set cm_cfg = users.get('cloudmaster', {}) %}
{%- if migrate_flag and cm_cfg.get('enabled', True) %}
{%-   set ub_info = salt['user.info']('ubuntu') %}

{%-   if ub_info and ub_info.get('name') %}

ubuntu-migration-note:
  test.succeed_without_changes:
    - name: "Ubuntu-Standarduser vorhanden – Migration/Absicherung aktiv (SSH & sudo werden eingeschränkt)."

# SSH-Login für ubuntu deaktivieren, indem authorized_keys entfernt wird.
ubuntu-disable-ssh-keys:
  file.absent:
    - name: /home/ubuntu/.ssh/authorized_keys
    - require:
      - test: ubuntu-migration-note

# Option: ubuntu weiterhin für lokale Konsole nutzbar, aber kein interaktives SSH-Shell-Login
ubuntu-lock-shell:
  user.present:
    - name: ubuntu
    - shell: /usr/sbin/nologin
    - require:
      - test: ubuntu-migration-note

# Entfernt ubuntu aus der sudo-Gruppe (falls noch Mitglied)
ubuntu-remove-from-sudo:
  cmd.run:
    - name: "deluser ubuntu sudo"
    - onlyif: "id -nG ubuntu | grep -qw sudo"
    - require:
      - test: ubuntu-migration-note

{%-   endif %}
{%- endif %}



