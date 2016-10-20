# This setup for mongodb assumes that the replica set can be determined from
# the id of the minion

{%- from 'mongodb/map.jinja' import cfg with context -%}

cfg_repo:
  pkgrepo.managed:
    - name: mongodb
    - humanname: MongoDB Repository
    - baseurl: https://repo.mongodb.org/yum/amazon/2013.03/mongodb-org/3.2/x86_64/
    - gpgcheck: 1
    - enabled: 1
    - gpgkey: https://www.mongodb.org/static/pgp/server-3.2.asc

cfg_package:
  pkg.installed:
    - name: {{ cfg.mongodb_package }}

cfg_log_path:
  file.directory:
    {%- if 'mongod_settings' in mdb %}
    - name: {{ salt['file.dirname'](cfg.mongod_settings.systemLog.path) }}
    {%- else %}
    - name: {{ cfg.log_path }}
    {%- endif %}
    - user: {{ cfg.mongodb_user }}
    - group: {{ cfg.mongodb_group }}
    - mode: 755
    - makedirs: True
    - recurse:
      - user
      - group

cfg_db_path:
  file.directory:
    {%- if 'mongod_settings' in cfg %}
    - name: {{ cfg.mongod_settings.storage.dbPath }}
    {%- else %}
    - name: {{ cfg.db_path }}
    {%- endif %}
    - user: {{ cfg.mongodb_user }}
    - group: {{ cfg.mongodb_group }}
    - mode: 755
    - makedirs: True
    - recurse:
      - user
      - group

cfg_config:
  file.managed:
    - name: {{ cfg.conf_path }}
    - source: salt://mongodb/files/mongodb.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644

cfg_service:
  service.running:
    - name: {{ cfg.mongod }}
    - enable: True
    - watch:
      - file: mongodb_config
