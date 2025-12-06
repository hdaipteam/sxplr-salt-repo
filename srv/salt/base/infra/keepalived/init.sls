# srv/salt/base/infra/keepalived/init.sls
# Einstiegspunkt für Keepalived-HA für Salt-Master (VIP 10.99.0.10)

{% set ka = pillar.get('keepalived', {}) %}

{% if ka.get('enable', True) %}

include:
  - infra.keepalived.pkg
  - infra.keepalived.config
  - infra.keepalived.service

{% else %}
keepalived-service-dead:
  service.dead:
    - name: keepalived
    - enable: False
{% endif %}
