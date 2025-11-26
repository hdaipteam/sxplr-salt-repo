# srv/salt/base/top.sls
# Mapping Rollen/Hosts → States

base:
  'mngm-001.*':
    - infra.salt.master
    - infra.security.ssh

  'mngm-002.*':
    - infra.salt.master
    - infra.security.ssh
