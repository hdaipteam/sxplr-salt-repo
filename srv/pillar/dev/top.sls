# srv/pillar/dev/top.sls
# Entwicklungs-spezifische Pillars

dev:
  'mngm-001.*':
    - dev.settings
