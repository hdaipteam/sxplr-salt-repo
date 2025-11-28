# srv/salt/base/infra/salt/master/grains.sls
# Leitet zentrale Pillar-Werte in ein statisches Grain "sxplr_master" ab
# und ist robust, egal ob "sxplr:role" ein Mapping oder ein String ist.

{%- set sxplr = salt['pillar.get']('sxplr', {}) %}
{%- set env = sxplr.get('env', 'base') %}

{# --- ROLE-Ableitung: Mapping ODER String -------------------------------- #}
{%- set role_raw = sxplr.get('role', {}) %}
{%- set role_type = 'management-master' %}
{%- set ha_role = 'single' %}
{%- set cluster = 'sxplr-mngm-ha-cluster' %}

{%- if role_raw is mapping %}
  {# Neue, "saubere" Variante: sxplr:role als Mapping im Pillar #}
  {%- set role_type = role_raw.get('type', role_type) %}
  {%- set ha_role  = role_raw.get('ha_role', ha_role) %}
  {%- set cluster  = role_raw.get('cluster', cluster) %}
{%- else %}
  {# Alte Variante: sxplr:role als String, z.B. "primary-master"/"secondary-master" #}
  {%- set role_str = (role_raw|string).lower() %}
  {%- if 'primary' in role_str %}
    {%- set ha_role = 'primary' %}
  {%- elif 'secondary' in role_str %}
    {%- set ha_role = 'secondary' %}
  {%- endif %}
{%- endif %}

{# --- MNGM-Teil ---------------------------------------------------------- #}
{%- set mngm = sxplr.get('mngm', {}) %}
{%- set node_id  = mngm.get('node_id', opts['id']) %}
{%- set hostname = mngm.get('hostname', grains['host']) %}
{%- set location = mngm.get('location', 'unknown') %}

{# --- salt_master-Teil --------------------------------------------------- #}
{%- set sm      = salt['pillar.get']('salt_master', {}) %}
{%- set sm_id   = sm.get('id', opts['id']) %}
{%- set sm_wg_ip = sm.get('wg_ip', '') %}
{%- set sm_ha    = sm.get('ha', {}) %}
{%- set sm_ha_peer_id    = sm_ha.get('peer_id', '') %}
{%- set sm_ha_peer_wg_ip = sm_ha.get('peer_wg_ip', '') %}

sxplr-master-grains:
  module.run:
    - name: grains.setval
    - key: sxplr_master
    - val:
        env: {{ env }}
        mngm:
          node_id: {{ node_id }}
          hostname: {{ hostname }}
          location: {{ location }}
        role:
          type: {{ role_type }}
          ha_role: {{ ha_role }}
          cluster: {{ cluster }}
        salt_master:
          id: {{ sm_id }}
          wg_ip: {{ sm_wg_ip }}
          ha_peer_id: {{ sm_ha_peer_id }}
          ha_peer_wg_ip: {{ sm_ha_peer_wg_ip }}



