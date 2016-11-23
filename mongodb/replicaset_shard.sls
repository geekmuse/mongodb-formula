{% if 'mongodb_role' in grains and grains['mongodb_role'] == 'primary' %}
  {%   if 'mongodb_replica_set_configured' not in grains or grains['mongodb_replica_set_configured'] != true %}

  mongo local --eval "printjson(rs.initiate())":
    cmd:
      - run

  {% set my_replica_set = grains['mongodb_replica_set'] %}
  {% set my_id = grains['hostname'] %}
  {% for host, value in salt['mine.get']('G@mongodb_replica_set:' + grains['mongodb_replica_set'], 'grains.items', expr_form='compound').items() %}
  {%     if value.hostname != my_id and 'mongo-shard' in value.roles and my_replica_set == value.mongodb_replica_set %}

  mongo local --eval "printjson(rs.add('{{ value.hostname }}:27017'))":
    cmd:
      - run

  {%     endif %}
  {% endfor %}

  mongodb_replica_set_configured:
    grains:
      - present
      - value: true

  {%   endif %}
  {% endif %}