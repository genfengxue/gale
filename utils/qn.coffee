require '../common/init'
qn = require 'qn'
async = require 'async'

client = qn.create(
  accessKey: process.env.accessKey
  secretKey: process.env.secretKey
  bucket: 'windenglish'
  domain: 'http://7u2qm8.com1.z0.glb.clouddn.com'
)

class QnUtils
  deleteFiles: ->
    funcName = "delete#{_u.convertToCamelCase arguments[0]}s"
    console.log arguments
    params = Array::slice.call arguments, 1
    console.log params, funcName
    @[funcName].apply @, params
#    console.log process.env.accessKey
#    console.log process.env.secretKey
#    console.log funcName
#    @["delete#{_u.convertToCamelCase fileType}"]
#    switch fileType
#      when 'image'
#        @[]

  deleteImages: (fileNameFormat, nums) ->
    async.eachSeries nums, (num, next) =>
      name = _s.sprintf fileNameFormat, num
      @processFile 'delete', name, next
    , ->
      console.log "process finished!"

  processFile: ->
    unless client[arguments[0]]
      return logger.error 'illegal method name for qn client'

    if arguments.length != 3 and arguments.length != 4
      return logger.error 'argument num should be 3 or 4'

    fileInfo = {}
    if arguments.length is 3
      fileInfo.fileName = arguments[1]
    else if arguments.length is 4
      fileInfo.oldName = arguments[1]
      fileInfo.newName = arguments[2]

    method = arguments[0]
    callback = arguments[arguments.length - 1]

    arguments[arguments.length - 1] = (err, result) ->
      if err
        logger.error err
      else
        logger.info result if result
        loggerD.write {type:"QINIU_#{method}", fileInfo: fileInfo}
      callback()

    params = Array::slice.call arguments, 1
    client[method].apply client, params

exports.QnUtils = QnUtils
