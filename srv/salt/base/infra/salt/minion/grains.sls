{# srv/salt/base/infra/salt/minion/grains.sls #}
{# Schreibt konsolidierte SXPLR-Grains nach /etc/salt/grains, basierend auf Pillar #}

{%- set sxplr = salt['pillar.get']('sxplr', {}) %}

{%- set env = sxplr.get('env', 'prod') %}

{%- set raw_role = sxplr.get('role', {}) %}
{%- if raw_role is mapping %}
  {%- set role = raw_role %}
{%- else %}
  {%- set role = {} %}
{%- endif %}

{%- set raw_mngm = sxplr.get('mngm', {}) %}
{%- if raw_mngm is mapping %}
  {%- set mngm = raw_mngm %}
{%- else %}
  {%- set mngm = {} %}
{%- endif %}

/etc/salt/grains:
  file.managed:
    - makedirs: True
    - mode: "0644"
    - user: root
    - group: root
    - contents: |
        sxplr:
          env: {{ env }}
          role:
            type: {{ role.get('type', 'management-master') }}
            ha_role: {{ role.get('ha_role', 'primary') }}
            cluster: {{ role.get('cluster', 'sxplr-mngm-ha-cluster') }}
          mngm:
            node_id: {{ mngm.get('node_id', '') }}
            hostname: {{ mngm.get('hostname', '') }}
            location: {{ mngm.get('location', '') }}

sxplr-grains-refresh:
  module.run:
    - name: saltutil.refresh_grains
    - onchanges:
      - file: /etc/salt/grains

