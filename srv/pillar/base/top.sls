# srv/pillar/base/top.sls
# Ordnet globale und Master-spezifische Pillars zu

base:
  '*':
    - global.settings

  'mngm-001.*':
    - mngm.mngm-001

  'mngm-002.*':
    - mngm.mngm-002