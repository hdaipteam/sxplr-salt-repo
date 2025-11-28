# srv/salt/base/top.sls
# Mapping Rollen/Hosts → States

base:
  'mngm-001.*':
    - roles.mngm_master

  'mngm-002.*':
    - roles.mngm_master
