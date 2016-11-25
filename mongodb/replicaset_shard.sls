{% if 'mongodb_role' in grains and grains['mongodb_role'] == 'primary' %}
  {% set my_replica_set = grains['mongodb_replica_set'] %}
  {% set my_id = grains['id'] %}
  {% set added = [] %}
  {% set checked_vals = [] %}
  {% if 'mongodb_replica_set_initiated' not in grains or grains['mongodb_replica_set_initiated'] != true %}

  mongo local --eval "printjson(rs.initiate())":
    cmd:
      - run

  mongodb_replica_set_initiated:
    grains:
      - present
      - value: true

  {% endif %}

  {% if 'mongodb_replica_set_configured' not in grains or grains['mongodb_replica_set_configured'] != true %}
    {% for host, data in salt['mine.get']('*', 'grains.items', expr_form = 'compound').items() -%}
      {% for key, value in data.items() -%}
        {% if key == 'id' %}
          {% if checked_vals.append(value) %}{% endif %}
        {% endif %}
        {% if key == 'mongodb_replica_set' %}
          {% if checked_vals.append(value) %}{% endif %}
        {% endif %}
      {% endfor -%}

      {% if my_id != checked_vals[0] and checked_vals[1] == my_replica_set %}

  mongo local --eval "printjson(rs.add('{{ checked_vals[0] }}:27017'))":
    cmd:
      - run

        {% if added.append(checked_vals[0]) %}{% endif %}
      {% endif %}
    {% endfor -%}

    {% if added|length > 0 %}

  mongodb_replica_set_configured:
    grains:
      - present
      - value: true

    {% endif %}
  {% endif %}

{% endif %}
