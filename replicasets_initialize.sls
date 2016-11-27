{% if 'mongodb_role' in grains and grains['mongodb_role'] == 'primary' %}
  {% set my_replica_set = grains['mongodb_replica_set'] %}
  {% set my_id = grains['id'] %}
  {% if 'mongodb_replica_set_initialized' not in grains or grains['mongodb_replica_set_initialized'] != true %}

  mongo local --eval "printjson(rs.initiate())":
    cmd:
      - run

  mongodb_replica_set_initialized:
    grains:
      - present
      - value: true

  {% endif %}
{% endif %}