# srv/pillar/prod/settings.sls
# Environment-spezifische Overrides für PROD

sxplr:
  env: prod
  role: primary-master
  description: "MNGM-002 (VPS) - produktiver externer Salt-Master"

  salt:
    master:
      # falls du später andere Ports oder Settings für PROD möchtest:
      pub_port: 4505
      ret_port: 4506
