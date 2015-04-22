require '../common/init'

#json = require "../local_data/others/user_info.json"
#
#User = _u.getModel 'user'
#User.createQ json
#.then (docs) ->
#  logger.info _.pluck docs, 'userNo'
#  logger.info 'create user success'
#, (err) ->
#  logger.info err

data = {
  userNo: 6
  role: 1
  password: '6'
}
User = _u.getModel 'user'
User.createQ data
.then (doc) ->
  logger.info doc
  logger.info 'create user success'
, (err) ->
  logger.info err
