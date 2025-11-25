# sxplr-salt-repo

Dieses Repository enthält die SaltStack-Konfiguration für:

- Proxmox VE 9 Cluster (WORK-/STOR-Nodes, WireGuard, VRF/SDN)
- zukünftige Cloud-Erweiterungen (GCP, Yandex Cloud, Firebase BaaS)
- Experimente in Richtung #DigitalHabitat (Mesh P2P)

Struktur (kurz):

- srv/salt/base      → generische States (rollen-/profil-basiert)
- srv/salt/dev       → dev-Environment, zusätzliche States/Services
- srv/salt/prod      → prod-Environment
- srv/pillar         → Pillar-Daten (base/dev/prod)
- doc                → Dokumentation

