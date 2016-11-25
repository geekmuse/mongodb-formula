{% if 'mongodb_role' in grains and grains['mongodb_role'] == 'primary' %}
{% set my_replica_set = grains['mongodb_replica_set'] %}
{% set my_id = grains['id'] %}
{% set checked_vals = [] %}
{% for host, data in salt['mine.get']('*', 'grains.items', expr_form = 'compound').items() -%}
{% for key, value in data.items() -%}
{% if key == 'id' %}

  {% if checked_vals.append(value) %}{% endif %}
/tmp/id:
  file.managed:
    - name: /tmp/{{ key }}/{{ checked_vals[0] }}/{{ salt['mine.get']('*', 'grains.items', expr_form = 'compound').items()|length }}
    - makedirs: True
{% endif %}

{% if key == 'mongodb_replica_set' %}

  {% if checked_vals.append(value) %}{% endif %}
/tmp/rs:
  file.managed:
    - name: /tmp/{{ key }}/{{ checked_vals[1] }}
    - makedidrs: True

{% endif %}

{% endfor -%}

  {% if my_id != checked_vals[0] and checked_vals[1] == my_replica_set %}

/tmp/match:
  file.managed:
    - name: /tmp/match/{{ my_id }}/{{ my_replica_set }}/{{ checked_vals[0] }}/{{ checked_vals[1] }}
    - makedirs: True

  {% else %}

/tmp/nomatch:
  file.managed:
    - name: /tmp/nomatch/{{ my_id }}/{{ my_replica_set }}/{{ checked_vals[0] }}/{{ checked_vals[1] }}
    - makedirs: True

  {% endif %}
{% endfor -%}
{% endif %}