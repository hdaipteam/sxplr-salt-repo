# srv/salt/base/infra/salt/minion/grains.sls
# Schreibt statische SXPLR-Grains aus den Pillar-Daten nach /etc/salt/grains

{%- set sxplr = salt['pillar.get']('sxplr', {}) %}
{%- set env = sxplr.get('env', 'prod') %}
{%- set role = sxplr.get('role', {}) %}
{%- set mngm = sxplr.get('mngm', {}) %}

/etc/salt/grains:
  file.managed:
    - makedirs: True
    - user: root
    - group: root
    - mode: "0644"
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

        sxplr_env: {{ env }}
        sxplr_role: {{ role.get('type', 'management-master') }}
        sxplr_mngm:
          node_id: {{ mngm.get('node_id', '') }}
          hostname: {{ mngm.get('hostname', '') }}
          location: {{ mngm.get('location', '') }}

minion-grains-sxplr:
  cmd.run:
    - name: salt-call --local saltutil.refresh_grains
    - onchanges:
      - file: /etc/salt/grains
