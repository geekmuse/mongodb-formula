{% if 'mongodb_role' in grains and grains['mongodb_role'] == 'primary' %}
  {%   if 'mongodb_replica_set_configured' not in grains or grains['mongodb_replica_set_configured'] != true %}

  mongo local --eval "printjson(rs.initiate())":
    cmd:
      - run

  mongodb_replica_set_configured:
    grains:
      - present
      - value: true

  {%   endif %}
  {% endif %}