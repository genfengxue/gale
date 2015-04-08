require '../common/init'

fs = require 'fs'

Sentence = _u.getModel 'sentence'
KeyPoint = _u.getModel 'key_point'
SentenceUtils = _u.getUtils 'sentence'

courseName = process.argv[2] or process.exit 1
unless Const.Course[courseName]
  logger.error 'wrong courseName, you should input de or nceone'
  process.exit 1

fileType = 'KeyPoint'
_u.getNeedToProcessFiles courseName, fileType, (err, needToProcessFiles) ->
  for file in needToProcessFiles
    datas = SentenceUtils.importKeyPoints courseName, file
