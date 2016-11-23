{% if 'mongodb_role' in grains and grains['mongodb_role'] == 'primary' %}
  {%   if 'mongodb_replica_set_configured' not in grains or grains['mongodb_replica_set_configured'] != true %}

  mongo local --eval "printjson(rs.initiate())":
    cmd:
      - run

  {% set my_replica_set = grains['mongodb_replica_set'] %}
  {% set my_id = grains['id'] %}
  {% for host, value in salt['mine.get']('environment_id:' + grains['environment_id'], 'grains.items', expr_form='grain').items() %}
  {%     if value.id != my_id and 'mongodb_server' in value.roles and my_replica_set == value.mongodb_replica_set %}

  mongo local --eval "printjson(rs.add('{{ value.id }}'))":
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