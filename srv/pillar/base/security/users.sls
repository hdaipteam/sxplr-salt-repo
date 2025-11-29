# srv/pillar/base/security/users.sls
# Zentrale Definition der SSH-User & Keys für alle SXPLR-Hosts

security:
  ssh:
    users:
      cloudmaster:
        enabled: true
        uid: 1100          # optional, kann weggelassen werden
        gid: 1100          # optional, kann weggelassen werden
        shell: /bin/bash
        home: /home/cloudmaster
        # zusätzliche Gruppen (z.B. sudo)
        groups:
          - sudo
        allow_uid_change: False   # Standard: NICHT erzwingen
        allow_gid_change: False
        authorized_keys:
          - "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDRRTXIP1PjGJdx89voimNXGTSptou5zADydZSTiTNV6 hdaipteam@yandex.com"
          # - "ssh-ed25519 AAAA...WEITERER_PUBKEY... kommentar"

