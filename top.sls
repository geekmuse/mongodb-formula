base:
  '*':
    - mongodb.saltmine

  'G@roles:mongo-router':
    - mongodb.mongos

  'G@roles:mongo-config':
    - mongodb

  'G@roles:mongo-shard':
    - mongodb
