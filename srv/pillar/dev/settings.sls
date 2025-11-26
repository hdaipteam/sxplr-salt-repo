# srv/pillar/dev/settings.sls
# Environment-spezifische Overrides für DEV

sxplr:
  env: dev
  role: secondary-master
  description: "MNGM-001 (VBOX) - temporärer, selbstverwalteter Dev-Master"

  salt:
    master:
      pub_port: 4505
      ret_port: 4506
