# srv/pillar/prod/top.sls
# Produktions-spezifische Pillars

prod:
  '*':
    - prod.settings
