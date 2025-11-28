# srv/salt/base/infra/salt/master/grains.sls
# Leitet zentrale Pillar-Werte in statische Grains ab (für MNGM-001/MNGM-002)

{%- set sxplr = salt['pillar.get']('sxplr', {}) %}
{%- set env = sxplr.get('env', 'base') %}

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

{%- set salt_master = salt['pillar.get']('salt_master', {}) %}
{%- set sm_id = salt_master.get('id', opts['id']) %}
{%- set sm_wg_ip = salt_master.get('wg_ip', '') %}
{%- set sm_ha = salt_master.get('ha', {}) %}
{%- set sm_ha_peer_id = sm_ha.get('peer_id', '') %}
{%- set sm_ha_peer_wg_ip = sm_ha.get('peer_wg_ip', '') %}

sxplr_master_grains:
  grains.present:
    - value:
        sxplr:
          env: {{ env }}
          role:
            type: {{ role.get('type', 'management-master') }}
            ha_role: {{ role.get('ha_role', 'single') }}
            cluster: {{ role.get('cluster', 'sxplr-mngm-ha-cluster') }}
          mngm:
            node_id: {{ mngm.get('node_id', opts['id']) }}
            hostname: {{ mngm.get('hostname', grains['host']) }}
            location: {{ mngm.get('location', 'unknown') }}
        salt_master:
          id: {{ sm_id }}
          wg_ip: {{ sm_wg_ip }}
          ha_peer_id: {{ sm_ha_peer_id }}
          ha_peer_wg_ip: {{ sm_ha_peer_wg_ip }}

