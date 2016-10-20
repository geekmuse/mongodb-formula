# This setup for mongodb assumes that the replica set can be determined from
# the id of the minion

{%- from 'mongodb/map.jinja' import mdb with context -%}

{%- if mdb.use_repo %}

mongodb_repo:
  pkgrepo.managed:
    - name=MongoDB Repository
    - baseurl=https://repo.mongodb.org/yum/amazon/2013.03/mongodb-org/3.2/x86_64/
    - gpgcheck=1
    - enabled=1
    - gpgkey=https://www.mongodb.org/static/pgp/server-3.2.asc

{%- endif %}

mongodb_package:
  pkg.installed:
    - name: {{ mdb.mongodb_package }}

mongodb_log_path:
  file.directory:
    {%- if 'mongod_settings' in mdb %}
    - name: {{ salt['file.dirname'](mdb.mongod_settings.systemLog.path) }}
    {%- else %}
    - name: {{ mdb.log_path }}
    {%- endif %}
    - user: {{ mdb.mongodb_user }}
    - group: {{ mdb.mongodb_group }}
    - mode: 755
    - makedirs: True
    - recurse:
      - user
      - group

mongodb_db_path:
  file.directory:
    {%- if 'mongod_settings' in mdb %}
    - name: {{ mdb.mongod_settings.storage.dbPath }}
    {%- else %}
    - name: {{ mdb.db_path }}
    {%- endif %}
    - user: {{ mdb.mongodb_user }}
    - group: {{ mdb.mongodb_group }}
    - mode: 755
    - makedirs: True
    - recurse:
      - user
      - group

mongodb_config:
  file.managed:
    - name: {{ mdb.conf_path }}
    - source: salt://mongodb/files/mongodb.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644

mongodb_service:
  service.running:
    - name: {{ mdb.mongod }}
    - enable: True
    - watch:
      - file: mongodb_config
