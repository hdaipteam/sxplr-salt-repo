# srv/pillar/dev/settings.sls
# Environment-spezifische Overrides für DEV

sxplr:
  env: dev

  salt:
    master:
      pub_port: 4505
      ret_port: 4506
