# srv/salt/base/infra/salt/master/grains.sls
# Leitet zentrale Pillar-Werte in statische Grains ab

{% set sxplr_env = salt['pillar.get']('sxplr:env', 'base') %}
{% set sxplr_role_type = salt['pillar.get']('sxplr:role:type', 'unknown') %}
{% set sxplr_ha_role = salt['pillar.get']('sxplr:role:ha_role', 'single') %}
{% set sxplr_cluster = salt['pillar.get']('sxplr:role:cluster', 'none') %}

{% set mngm_node_id = salt['pillar.get']('sxplr:mngm:node_id', opts['id']) %}
{% set mngm_hostname = salt['pillar.get']('sxplr:mngm:hostname', grains['host']) %}
{% set mngm_location = salt['pillar.get']('sxplr:mngm:location', 'unknown') %}

{% set salt_master_id = salt['pillar.get']('salt_master:id', opts['id']) %}
{% set salt_master_wg_ip = salt['pillar.get']('salt_master:wg_ip', '') %}
{% set salt_master_ha_peer_id = salt['pillar.get']('salt_master:ha:peer_id', '') %}
{% set salt_master_ha_peer_wg_ip = salt['pillar.get']('salt_master:ha:peer_wg_ip', '') %}

sxplr_master_grains:
  grains.present:
    - value:
        sxplr_env: {{ sxplr_env }}
        sxplr_role:
          type: {{ sxplr_role_type }}
          ha_role: {{ sxplr_ha_role }}
          cluster: {{ sxplr_cluster }}
        sxplr_mngm:
          node_id: {{ mngm_node_id }}
          hostname: {{ mngm_hostname }}
          location: {{ mngm_location }}
        salt_master:
          id: {{ salt_master_id }}
          wg_ip: {{ salt_master_wg_ip }}
          ha_peer_id: {{ salt_master_ha_peer_id }}
          ha_peer_wg_ip: {{ salt_master_ha_peer_wg_ip }}
