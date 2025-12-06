# srv/salt/base/infra/keepalived/service.sls

keepalived-service:
  service.running:
    - name: keepalived
    - enable: True
    - require:
      - pkg: keepalived-pkg
      - file: keepalived-config
      - file: keepalived-check-script
    - watch:
      - file: keepalived-config
      - file: keepalived-check-script
