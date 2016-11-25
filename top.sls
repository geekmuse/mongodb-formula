base:
  '*':
    - saltmine

  'G@roles:mongo-router':
    - mongodb.mongos

  'G@roles:mongo-shard':
    - mongodb
    - mongodb.replicaset_shard
