# srv/salt/base/infra/security/users.sls
# User-Management & SSH-Keys auf Basis der Pillars

{%- set ssh_cfg = pillar.get('security', {}).get('ssh', {}) %}
{%- set users = ssh_cfg.get('users', {}) %}

{%- for username, u in users.items() %}
{%-   if u.get('enabled', True) %}

{{ username }}-group:
  group.present:
    - name: {{ username }}

{{ username }}-user:
  user.present:
    - name: {{ username }}
    - home: {{ u.get('home', '/home/' ~ username) }}
    - shell: {{ u.get('shell', '/bin/bash') }}
    - createhome: True
    - gid_from_name: True
    - require:
      - group: {{ username }}-group

{{ username }}-ssh-dir:
  file.directory:
    - name: {{ u.get('home', '/home/' ~ username) }}/.ssh
    - user: {{ username }}
    - group: {{ username }}
    - mode: "0700"
    - makedirs: True
    - require:
      - user: {{ username }}-user

{%-   for key in u.get('authorized_keys', []) %}

{{ username }}-ssh-key-{{ loop.index }}:
  ssh_auth.present:
    - user: {{ username }}
    - name: {{ key }}
    - require:
      - file: {{ username }}-ssh-dir

{%-   endfor %}
{%-   endif %}
{%- endfor %}
