# srv/salt/base/roles/mngm_master.sls
# Rolle für beide Management-Master (MNGM-001 & MNGM-002)

include:
  - infra.salt.master    # Git-Repo, roots.conf, systemd, etc.
  - infra.salt.minion    # falls du einen Sammel-State infra/salt/minion/init.sls hast
  - infra.security.ssh   # SSH-Basishärtung
  