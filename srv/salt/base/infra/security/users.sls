# srv/salt/base/infra/security/users.sls
# User-Management & SSH-Keys auf Basis der Pillars
# Kompatibel mit älteren Salt-Versionen (kein gid_from_name)

{%- set ssh_cfg = pillar.get('security', {}).get('ssh', {}) %}
{%- set users = ssh_cfg.get('users', {}) %}

{# ---------------------------------------------------------
   1. Normale SSH-User aus security:ssh:users
   --------------------------------------------------------- #}

{%- for username, u in users.items() %}
{%-   if u.get('enabled', True) %}

{%-     set home = u.get('home', '/home/' ~ username) %}
{%-     set shell = u.get('shell', '/bin/bash') %}
{%-     set uid = u.get('uid') %}
{%-     set gid = u.get('gid') %}
{%-     set groups = u.get('groups', []) %}
{%-     set auth_keys = u.get('authorized_keys', []) %}

{{ username }}-group:
  group.present:
    - name: {{ username }}
    {%- if gid is not none %}
    - gid: {{ gid }}
    {%- endif %}

{{ username }}-user:
  user.present:
    - name: {{ username }}
    - home: {{ home }}
    - shell: {{ shell }}
    - createhome: True
    {%- if uid is not none %}
    - uid: {{ uid }}
    {%- endif %}
    {%- if gid is not none %}
    - gid: {{ gid }}
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

