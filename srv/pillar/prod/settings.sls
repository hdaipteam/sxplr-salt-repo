# srv/pillar/prod/settings.sls
# Environment-spezifische Overrides für PROD

sxplr:
  env: prod

  salt:
    master:
      # falls du später andere Ports oder Settings für PROD möchtest:
      pub_port: 4505
      ret_port: 4506
