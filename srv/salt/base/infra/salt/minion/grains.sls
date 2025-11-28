# srv/salt/base/infra/salt/minion/grains.sls
# Schreibt eigene Grains für sxplr_* basierend auf den Pillar-Daten

{%- set sxplr = salt['pillar.get']('sxplr', {}) %}

{%- set sxplr_env = sxplr.get('env', 'prod') %}
{%- set sxplr_role_raw = sxplr.get('role', {}) %}
{%- set mngm = sxplr.get('mngm', {}) %}

{# 
  sxplr.role kann entweder ein String ODER ein Dict sein.
  - String: "secondary-master"
  - Dict:   {type: management-master, ha_role: primary, cluster: ...}
#}
{%- if sxplr_role_raw is mapping %}
  {%- set role_type = sxplr_role_raw.get('type', 'management-master') %}
  {%- set ha_role = sxplr_role_raw.get('ha_role', 'primary') %}
  {%- set cluster = sxplr_role_raw.get('cluster', 'sxplr-mngm-ha-cluster') %}
{%- else %}
  {# String oder gar nichts #}
  {%- set role_type = sxplr_role_raw or 'management-master' %}
  {%- set ha_role = 'primary' %}
  {%- set cluster = 'sxplr-mngm-ha-cluster' %}
{%- endif %}

{%- set salt_master = salt['pillar.get']('salt_master', {}) %}

{%- set sm_id = salt_master.get('id', '') %}
{%- set sm_hostname = salt_master.get('hostname', '') %}
{%- set sm_wg_ip = salt_master.get('wg_ip', '') %}

/etc/salt/minion.d/sxplr_grains.conf:
  file.managed:
    - makedirs: True
    - user: root
    - group: root
    - mode: "0644"
    - contents: |
        sxplr_env: {{ sxplr_env }}
        sxplr_role: {{ role_type }}
        sxplr_cluster: {{ cluster }}
        sxplr_ha_role: {{ ha_role }}
        sxplr_mngm:
          node_id: {{ mngm.get('node_id', '') }}
          hostname: {{ mngm.get('hostname', '') }}
          location: {{ mngm.get('location', '') }}

        salt_master:
          id: {{ sm_id }}
          hostname: {{ sm_hostname }}
          wg_ip: {{ sm_wg_ip }}

