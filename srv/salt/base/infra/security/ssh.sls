# srv/salt/base/infra/security/ssh.sls
# SSH-Hardening-Example

/etc/ssh/sshd_config:
  file.managed:
    - source: salt://infra/security/files/sshd_config.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: '0600'

sshd:
  service.running:
    - name: ssh
    - enable: true
