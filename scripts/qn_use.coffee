require '../common/init'
qn = require 'qn'
fs = require 'fs'
async = require 'async'

# accessKey=xxxxx secretKey=yyyyy coffee scripts/qn_use.coffee
QnUtils = _u.getUtils 'qn'
#imageNames = QnUtils.buildImageNames 'de%03s.JPG', [82..100]
#QnUtils.buildVideoNames '2_%s_%s.mp4', [82..100]
#QnUtils.deleteVideos '2_%s_%s.mp4', [82..100]
nums = _.select [1..19], (num) ->
  return num % 2
QnUtils.copyVideos 'nceone%03s_%s.mp4', '1_%s_%s.mp4', nums

nums = _.select [21..69], (num) ->
  return num % 2
QnUtils.copyVideos 'nceone%03s-%s.mp4', '1_%s_%s.mp4', nums

#QnUtils.deleteImages 'de%03s.JPG', [82..100]
#QnUtils.deleteFiles 'video'

#deleteVideo = (fileNameFormat, videoNum, cb) ->
#  async.eachSeries [1..4], (part, next) ->
#    fileName = _s.sprintf fileNameFormat, videoNum, part
##    console.log fileName
##    next()
#    client.delete fileName, (err) ->
#      if err
#        console.log fileName, err
#      else
#        loggerD.write {type:"QINIU_delete", fileName: fileName}
#      next()
#  , cb
#
#async.eachSeries [82..100], (videoNum, next) ->
##  fileNameFormat = 'de%03s_%s.mp4'
#  fileNameFormat = '2_%s_%s.mp4'
#  deleteVideo fileNameFormat, videoNum, next
#, (err) ->
#  console.log "process result: success"

#copyVideo = (srcFormat, dstFormat, videoNum, cb) ->
#  copyVideoByDiffNum srcFormat, dstFormat, videoNum, videoNum, cb
#
#copyVideoByDiffNum = (srcFormat, dstFormat, srcVideoNum, dstVideoNum, cb) ->
#  async.eachSeries [1..4], (part, next) ->
#    oldName = _s.sprintf srcFormat, srcVideoNum, part
#    newName = _s.sprintf dstFormat, dstVideoNum, part
##    console.log oldName, newName
##    next()
#    client.copy oldName, newName, (err) ->
#      return next err if err
#      loggerD.write {type:"QINIU_copy", oldName: oldName, newName: newName}
#      next()
#  , cb
#
##copy course 1 mp4 file
#videoNums = _.select [71..143], (num) ->
#  return num % 2
#async.eachSeries videoNums, (videoNum, next) ->
#  srcFormat = 'video%s_%s.mp4'
#  dstFormat = '1_%s_%s.mp4'
#  copyVideoByDiffNum srcFormat, dstFormat, 300 + videoNum, videoNum, next
#, (err) ->
#  console.log err if err
#  console.log "process result: success"

#copy mp4 file
#async.eachSeries [1..81], (videoNum, next) ->
#  srcFormat = 'video%s_%s.mp4'
#  dstFormat = '2_%s_%s.mp4'
#  copyVideo srcFormat, dstFormat, videoNum, next
#, (err) ->
#  console.log err if err
#  console.log "process result: success"
#
#async.eachSeries [82..100], (videoNum, next) ->
#  srcFormat = 'de%03s_%s.mp4'
#  dstFormat = '2_%s_%s.mp4'
#  copyVideo srcFormat, dstFormat, videoNum, next
#, (err) ->
#  console.log err if err
#  console.log "process result: success"

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
#dataPath = "/Users/lutao/Downloads/nceone001-143-1"
#
#uploadFile = (fileName, cb) ->
#  client.uploadFile "#{dataPath}/#{fileName}", {key: "de#{fileName}"}, (err, result) ->
#    return cb err if err
#    console.log result
#    loggerD.write {type:"QINIU_upload", fileName: fileName}
#    cb()
#
#fs.readdir dataPath, (err, files) ->
#  return console.log err if err
#  async.eachSeries files, (file, next) ->
#    if /.jpg/i.test file
##      console.log file
##      next()
#      uploadFile file, next
#    else
#      next()
#  , (err) ->
#    console.log err if err
#    logger.info "process result: success"
