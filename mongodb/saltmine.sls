saltmine:
  file.managed:
    - name: /etc/salt/minion.d/80_saltmine.conf
    - unless: ls /etc/salt/minion.d/80_saltmine.conf
    - user: root
    - group: root
    - template: jinja
    - mode: 644
    - source: salt://mongodb/files/mine.conf.jinja