base:
  '*':
    - mongodb.saltmine

  'G@roles:mongo-router':
    - mongodb.mongos

  'G@roles:mongo-shard':
    - mongodb
