{%- from "mongodb/map.jinja" import ms with context -%}

mongos_package:
{%- if ms.use_repo %}
  pkgrepo.managed:
    - humanname: MongoDB Repository
    - baseurl: https://repo.mongodb.org/yum/amazon/2013.03/mongodb-org/3.2/x86_64/
    - gpgcheck: 1
    - enabled: 1
    - gpgkey: https://www.mongodb.org/static/pgp/server-3.2.asc
{%- endif %}
  pkg.installed:
    - name: {{ ms.mongos_package }}

{%- if ms.use_repo %}
mongo_shell:
  pkg.installed:
    - name: {{ ms.mongo_shell }}
{%- endif %}

mongos_user:
  user.present:
    - name: {{ ms.mongos_user }}
    - gid_from_name: True
    - home: {{ ms.mongos_user_home }}
    - shell: /bin/sh
    - system: True
    - require:
      - group: mongos_group

mongos_group:
  group.present:
    - name: {{ ms.mongos_group }}
    - system: True

mongos_log_path:
  file.directory:
{%- if 'mongos_settings' in ms %}
    - name: {{ salt['file.dirname'](ms.mongos_settings.systemLog.path) }}
{%- else %}
    - name: {{ ms.log_path }}
{%- endif %}
    - user: {{ ms.mongos_user }}
    - group: {{ ms.mongos_group }}
    - mode: 755
    - makedirs: True

mongos_init:
  file.managed:
    - name: {{ ms.init_file }}
    - source: {{ ms.init_file_template }}
    - template: jinja
    - user: root
    - group: root
    - mode: 755

mongos_config:
  file.managed:
    - name: {{ ms.conf_path }}
    - source: salt://mongodb/files/mongos.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644

/var/run/mongo:
  file.directory:
    - user: {{ ms.mongos_user }}
    - group: {{ ms.mongos_group }}
    - mode: 755
    - makedirs: True

/etc/sysconfig/mongos:
  file.touch

mongos_service:
  service.running:
    - name: {{ ms.mongos }}
    - enable: True
    - watch:
      - file: mongos_config
