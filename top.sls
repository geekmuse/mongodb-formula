base:
  '*':
    - mongodb.saltmine
    - mongodb.tools

  'G@roles:mongo-router':
    - mongodb.mongos

  'G@roles:mongo-shard':
    - mongodb
