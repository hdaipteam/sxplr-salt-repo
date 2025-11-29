# # srv/salt/base/orchestrate/mngm_master_ha.sls
# # Orchestrate: Management-Master (MNGM-001 & MNGM-002) synchron halten
# # Dieser Orchestrate-State läuft jeweils auf dem lokalen Salt-Master

# refresh_pillar_mngm:
#   salt.function:
#     - name: saltutil.refresh_pillar
#     - tgt: 'G@role:mngm_master'
#     - tgt_type: grain

# sync_modules_mngm:
#   salt.function:
#     - name: saltutil.sync_all
#     - tgt: 'G@role:mngm_master'
#     - tgt_type: grain
#     - require:
#       - salt: refresh_pillar_mngm

# apply_role_mngm_master:
#   salt.state:
#     - tgt: 'G@role:mngm_master'
#     - tgt_type: grain
#     - sls:
#       - roles.mngm_master
#     - saltenv: base
#     - require:
#       - salt: sync_modules_mngm

# srv/salt/base/orchestrate/mngm_master_sync.sls
# Orchestrate: Management-Master (MNGM-001 & MNGM-002) synchron halten
# Ziel: alle Minions mit sxplr:role:type == management-master

refresh_pillar_mngm:
  salt.function:
    - name: saltutil.refresh_pillar
    - tgt: 'G@sxplr:role:type:management-master'
    - tgt_type: grain

sync_modules_mngm:
  salt.function:
    - name: saltutil.sync_all
    - tgt: 'G@sxplr:role:type:management-master'
    - tgt_type: grain
    - require:
      - salt: refresh_pillar_mngm

apply_role_mngm_master:
  salt.state:
    - tgt: 'G@sxplr:role:type:management-master'
    - tgt_type: grain
    - sls:
      - roles.mngm_master
    - saltenv: base
    - require:
      - salt: sync_modules_mngm