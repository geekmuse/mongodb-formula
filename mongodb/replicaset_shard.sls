{% if 'mongodb_role' in grains and grains['mongodb_role'] == 'primary' %}
  {%   if 'mongodb_replica_set_configured' not in grains or grains['mongodb_replica_set_configured'] != true %}

  mongo local --eval "printjson(rs.initiate())":
    cmd:
      - run

  {% set my_replica_set = grains['mongodb_replica_set'] %}
  {% set my_id = grains['hostname'] %}


  mongodb_replica_set_initiated:
    grains:
      - present
      - value: true

  {%   endif %}
  {% endif %}