base:
  'G@roles:mongo-router':
    - mongodb.mongos

  'G@roles:mongo-shard':
    - mongodb
    - replicaset_shard