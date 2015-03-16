require '../common/init'
crypto = require 'crypto'
User = _u.getModel 'user'

start = 20150001
end = 20150100

students = (
  for i in [start..end]
    sha1Hash = crypto.createHash('sha1')
    studentNo: i
    password: (sha1Hash.update(i.toString()).digest('hex')).substr 0, 6
)

User.createQ students
.then (docs) ->
  logger.info _.pluck docs, 'studentNo'
, (err) ->
  logger.info err
