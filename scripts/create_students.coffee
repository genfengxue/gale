require '../common/init'
crypto = require 'crypto'

start = 20150001
end = 20150100

students = (
  for i in [start..end]
    sha1Hash = crypto.createHash('sha1')
    userNo: i
    password: (sha1Hash.update(i.toString()).digest('hex')).substr 0, 6
)

#将学生初始信息存为json文件
#jsonPath = "local_data/others/students#{start}_#{end}.json"
#data = JSON.stringify students, null, 4
#fs = require 'fs'
#fs.writeFile jsonPath, data + "\n", (err) ->
#  if err then return logger.info err
#  logger.info "create #{jsonPath} success"

#将学生信息导入数据库
User = _u.getModel 'user'
User.createQ students
.then (docs) ->
  logger.info _.pluck docs, 'userNo'
, (err) ->
  logger.info err
