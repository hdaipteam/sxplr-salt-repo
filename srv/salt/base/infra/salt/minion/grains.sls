# srv/salt/base/infra/salt/minion/grains.sls
# Setzt persistente Grains basierend auf den SXPLR-Pillar-Daten

{%- set sxplr = salt['pillar.get']('sxplr', {}) %}
{%- set role  = sxplr.get('role', {}) %}
{%- set mngm  = sxplr.get('mngm', {}) %}

minion-grains-file:
  file.managed:
    - name: /etc/salt/minion.d/10-sxplr-grains.conf
    - user: root
    - group: root
    - mode: "0644"
    - makedirs: True
    - contents: |
        sxplr:
          env: {{ sxplr.get('env', 'prod') }}
          role:
            type: {{ role.get('type', 'management-master') }}
            ha_role: {{ role.get('ha_role', 'primary') }}
            cluster: {{ role.get('cluster', 'sxplr-mngm-ha-cluster') }}
          mngm:
            node_id: {{ mngm.get('node_id', '') }}
            hostname: {{ mngm.get('hostname', '') }}
            location: {{ mngm.get('location', '') }}
