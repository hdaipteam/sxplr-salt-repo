{% set masters = pillar.get('salt_master', {}) %}

ha-wireguard-allow:
  firewalld.present:
    - name: public
    - port:
      - 4505/tcp
      - 4506/tcp
    - permanent: True
    - immediate: True

ha-master-discovery-script:
  file.managed:
    - name: /usr/local/bin/salt-master-ha-check
    - mode: "0755"
    - user: root
    - group: root
    - contents: |
        #!/bin/bash
        PRIMARY="{{ masters.get('primary_ip', '10.99.0.250') }}"
        SECONDARY="{{ masters.get('secondary_ip', '10.99.0.251') }}"

        ping -c1 -W1 "$PRIMARY" >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo "primary"
            exit 0
        fi

        ping -c1 -W1 "$SECONDARY" >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo "secondary"
            exit 0
        fi

        echo "none"
        exit 1

ha-master-health-service:
  file.managed:
    - name: /etc/systemd/system/salt-master-ha.service
    - mode: "0644"
    - user: root
    - group: root
    - contents: |
        [Unit]
        Description=Salt Master HA Health Check
        After=network-online.target

        [Service]
        Type=simple
        ExecStart=/usr/local/bin/salt-master-ha-check
        Restart=always
        RestartSec=15

        [Install]
        WantedBy=multi-user.target

systemd-daemon-reload-ha:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: ha-master-health-service

enable-ha-service:
  service.running:
    - name: salt-master-ha
    - enable: True