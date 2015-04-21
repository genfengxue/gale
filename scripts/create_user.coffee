require '../common/init'

json = require "../local_data/others/user_info.json"

User = _u.getModel 'user'
User.createQ json
.then (docs) ->
  logger.info _.pluck docs, 'userNo'
  logger.info 'create user success'
, (err) ->
  logger.info err
