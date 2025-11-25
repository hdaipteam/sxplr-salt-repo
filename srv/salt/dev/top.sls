# srv/salt/dev/top.sls
# Entwicklungs-spezifische States (z.B. zusätzliche Debug-Tools)

dev:
  '*':
    - dev.services.common
