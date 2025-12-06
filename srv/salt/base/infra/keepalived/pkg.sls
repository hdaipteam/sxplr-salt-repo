# srv/salt/base/infra/keepalived/pkg.sls

keepalived-pkg:
  pkg.installed:
    - name: keepalived
