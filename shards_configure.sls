{% set added_replica_sets = [] %}
{% if 'roles' in grains and grains['roles'] == 'mongo-router' %}
  {% if 'mongodb_shards_added_to_routers' not in grains or grains['mongodb_shards_added_to_routers'] != true %}

    {% for host, data in salt['mine.get']('*', 'grains.items', expr_form = 'compound').items() -%}
      {% if 'mongodb_replica_set' in data and 'mongodb_role' in data and data['mongodb_role'] == 'primary' and data['roles'] != 'mongo-config' %}
        {% set repl_set = data['mongodb_replica_set'] %}
        {% set repl_set_primary = data['id'] %}

  mongo local --eval "printjson(sh.addShard('{{ repl_set }}/{{ repl_set_primary }}:27017'))":
    cmd:
      - run

        {% if added_replica_sets.append(repl_set) %}{% endif %}
      {% endif %}     
    {% endfor -%}

    {% if added_replica_sets|length == 3 %}

  mongodb_shards_added_to_routers:
    grains:
      - present
      - value: true

    {% endif %}
  {% endif %}
{% endif %}