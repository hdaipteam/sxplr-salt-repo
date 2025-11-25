# srv/pillar/base/top.sls
# Basis-Pillars (clusterweite Einstellungen)

base:
  '*':
    - global.settings
