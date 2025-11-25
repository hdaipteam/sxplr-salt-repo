# srv/salt/prod/top.sls
# Produktions-spezifische States

prod:
  '*':
    - prod.services.monitoring
