# srv/salt/base/infra/security/users.sls
# Robustes User-Management & SSH-Keys auf Basis der Pillars
# - ändert UID/GID nur, wenn es gefahrlos möglich ist
# - bricht nicht ab, wenn User bereits mit anderer UID existiert

{%- set ssh_cfg = pillar.get('security', {}).get('ssh', {}) %}
{%- set users = ssh_cfg.get('users', {}) %}

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
   1. Gruppe anlegen/prüfen
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
   2. User anlegen/prüfen (ohne harte UID-Zwangsänderung)
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
   3. .ssh-Verzeichnis & authorized_keys
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


