/tmp/dumpgrains:
  file.managed:
    - name: /tmp/dumpgrains
    - source: salt://mongodb/dumpgrains.jinja
    - owner: root
    - group: root
    - template: jinja