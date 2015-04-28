require '../common/init'
qn = require 'qn'
async = require 'async'

client = qn.create(
  accessKey: process.env.accessKey
  secretKey: process.env.secretKey
  bucket: 'windenglish'
  domain: 'http://7u2qm8.com1.z0.glb.clouddn.com'
)

#改写成支持操作和类型两种参数
class QnUtils
  deleteFilesByType: (type, fileNameFormat, nums) ->
    buildFileNamesFunc = "build#{_u.convertToCamelCase type}Names"
    fileNames = @[buildFileNamesFunc] fileNameFormat, nums
#    console.log fileNames
    @deleteFiles fileNames

  deleteImages: (fileNameFormat, nums) ->
    @deleteFilesByType 'image', fileNameFormat, nums

  deleteVideos: (fileNameFormat, nums) ->
    @deleteFilesByType 'video', fileNameFormat, nums

  buildVideoNames: (fileNameFormat, nums) ->
    results = []
    _.each nums, (num) ->
      _.each [1..4], (part) ->
        results.push _s.sprintf fileNameFormat, num, part
    return results

  buildImageNames: (fileNameFormat, nums) ->
    return (
      for num in nums
        _s.sprintf fileNameFormat, num
    )

  copyImages: (srcFormat, dstFormat, nums) ->
    srcFileNames = @buildImageNames srcFormat, nums
    dstFileNames = @buildImageNames dstFormat, nums
    async.eachSeries [0..srcFileNames.length - 1], (index, next) =>
#      console.log srcFileNames[index], dstFileNames[index]
#      next()
      @processFile 'copy', srcFileNames[index], dstFileNames[index], next
    , ->
      console.log "process finished!"

  copyVideos: (srcFormat, dstFormat, nums) ->
    srcFileNames = @buildVideoNames srcFormat, nums
    dstFileNames = @buildVideoNames dstFormat, nums
    async.eachSeries [0..srcFileNames.length - 1], (index, next) =>
#      console.log srcFileNames[index], dstFileNames[index]
#      next()
      @processFile 'copy', srcFileNames[index], dstFileNames[index], next
    , ->
      console.log "process finished!"

  deleteFiles: (fileNames) ->
    async.eachSeries fileNames, (fileName, next) =>
      @processFile 'delete', fileName, next
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
