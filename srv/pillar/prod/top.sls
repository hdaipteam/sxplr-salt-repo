# srv/pillar/prod/top.sls
# Produktions-spezifische Pillars

prod:
  'mngm-002.*':
    - prod.settings
