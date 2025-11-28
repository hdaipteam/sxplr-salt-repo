# srv/salt/base/infra/salt/master/config.sls
# Basis-Konfiguration für Salt-Master: Git-Repo, /srv-Symlinks, roots.conf

{%- set sxplr = pillar.get("sxplr", {}) %}
{%- set git_cfg = sxplr.get("git", {}) %}
{%- set repo_path = git_cfg.get("path", "/opt/sxplr-salt-repo") %}

# Sicherstellen, dass der lokale Repo-Pfad existiert
{{ repo_path }}:
  file.directory:
    - user: root
    - group: root
    - mode: "0755"

/srv:
  file.directory:
    - user: root
    - group: root
    - mode: "0755"

/srv/salt:
  file.symlink:
    - target: {{ repo_path }}/srv/salt
    - require:
      - file: /srv
      - file: {{ repo_path }}

/srv/pillar:
  file.symlink:
    - target: {{ repo_path }}/srv/pillar
    - require:
      - file: /srv
      - file: {{ repo_path }}

# master.d-Verzeichnis
/etc/salt/master.d:
  file.directory:
    - user: root
    - group: root
    - mode: "0755"

# roots.conf aus Pillar-Template
/etc/salt/master.d/roots.conf:
  file.managed:
    - source: salt://infra/salt/master/files/roots.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: "0644"
