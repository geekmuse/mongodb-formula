{%- from "mongodb/map.jinja" import mdb with context -%}

pymongo_package:
  pip.installed:
    - name: pymongo
    # This is needed for mongodb_* states to work in the same Salt job
    - reload_modules: True
    - require:
      - pkg: python_pip
