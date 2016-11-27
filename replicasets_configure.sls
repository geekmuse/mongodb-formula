{% set added = [] %}
{% if 'mongodb_role' in grains and grains['mongodb_role'] == 'primary' %}
  {% if 'mongodb_replica_set_initialized' in grains and grains['mongodb_replica_set_initialized'] == true %}
    {% set my_replica_set = grains['mongodb_replica_set'] %}
    {% set my_id = grains['id'] %}
    {% for host, data in salt['mine.get']('*', 'grains.items', expr_form = 'compound').items() -%}
      {% set checked_host = data['id'] %}
      {% if 'mongodb_replica_set' in data %}
        {% set checked_replica_set = data['mongodb_replica_set'] %}
        {% if my_id != checked_host and checked_replica_set == my_replica_set %}

  mongo local --eval "printjson(rs.add('{{ checked_host }}:27017'))":
    cmd:
      - run

          {% if added.append(checked_host) %}{% endif %}
        {% endif %}
      {% endif %}
    {% endfor -%}

    {% if added|length == 2 and 'mongodb_replica_set_configured' not in grains %}

  mongodb_replica_set_configured:
    grains:
      - present
      - value: true

    {% endif %}
  {% endif %}
{% endif %}