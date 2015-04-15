require '../common/init'
qn = require 'qn'
fs = require 'fs'
async = require 'async'

# accessKey=xxxxx secretKey=yyyyy coffee scripts/qn_use.coffee

client = qn.create(
  accessKey: process.env.accessKey
  secretKey: process.env.secretKey
  bucket: 'windenglish'
  domain: 'http://7u2qm8.com1.z0.glb.clouddn.com'
)

copyVideo = (srcFormat, dstFormat, videoNum, cb) ->
  async.eachSeries [1..4], (part, next) ->
    oldName = _s.sprintf srcFormat, videoNum, part
    newName = _s.sprintf dstFormat, videoNum, part
#    console.log oldName, newName
#    next()
    client.copy oldName, newName, (err) ->
      return next err if err
      loggerD.write {type:"QINIU_copy", oldName: oldName, newName: newName}
      next()
  , cb

#copy mp4 file
async.eachSeries [1..81], (videoNum, next) ->
  srcFormat = 'video%s_%s.mp4'
  dstFormat = '2_%s_%s.mp4'
  copyVideo srcFormat, dstFormat, videoNum, next
, (err) ->
  console.log err if err
  console.log "process result: success"

async.eachSeries [82..100], (videoNum, next) ->
  srcFormat = 'de%03s_%s.mp4'
  dstFormat = '2_%s_%s.mp4'
  copyVideo srcFormat, dstFormat, videoNum, next
, (err) ->
  console.log err if err
  console.log "process result: success"

#copy file
#async.each [82..100], (num, next) ->
#  oldName = _s.sprintf 'de%03s.JPG', num
#  newName = _s.sprintf 'de%03s.jpg', num
#  client.copy oldName, newName, (err) ->
#    return next err if err
#    logger.info "QINIU: copy #{oldName} => #{newName}"
#    next()
#, (err) ->
#  console.log err if err
#  console.log "process result: success"

# delete 1-81
#async.each [1..81], (num, next) ->
#  name = _s.sprintf 'de%02s.JPG', num
#  client.delete name, (err) ->
#    return next err if err
#    logger.info "QINIU: delete #{name}"
#    next()
#, (err) ->
#  console.log err if err
#  console.log "process result: success"


#deleteFile
#files = require '../local_data/others/video_file_list_to_be_deleted.json'
#console.log files
#async.each files, (file, next) ->
#  client.delete file, next
#, (err) ->
#  console.log err if err
#  console.log "process result: success"



#uploadFile
###
dataPath = "/Users/lutao/Downloads/direct_english_lesson_list"

uploadFile = (fileName, cb) ->
  client.uploadFile "#{dataPath}/#{fileName}", {key: "de#{fileName}"}, (err, result) ->
    return cb err if err
    console.log result
    cb()

fs.readdir dataPath, (err, files) ->
  return console.log err if err
  async.each files, (file, next) ->
    if /.jpg/i.test file
#      console.log file
#      next()
      uploadFile file, next
    else
      next()
  , (err) ->
    console.log err if err
###
