# srv/salt/base/infra/keepalived/config.sls

{% set ka = pillar.get('keepalived', {}) %}
{% set vrrp_instance = ka.get('vrrp_instance', 'VI_SXPLR_SALT') %}

keepalived-dir:
  file.directory:
    - name: /etc/keepalived
    - user: root
    - group: root
    - mode: "0755"
    - require:
      - pkg: keepalived-pkg

keepalived-check-script:
  file.managed:
    - name: /etc/keepalived/check_salt.sh
    - source: salt://infra/keepalived/files/check_salt.sh
    - user: root
    - group: root
    - mode: "0755"
    - require:
      - file: keepalived-dir

keepalived-config:
  file.managed:
    - name: /etc/keepalived/keepalived.conf
    - source: salt://infra/keepalived/files/keepalived.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: "0644"
    - require:
      - file: keepalived-dir
      - file: keepalived-check-script
    - context:
        keepalived: {{ ka | tojson }}
