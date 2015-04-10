require '../common/init'

fs = require 'fs'

# coffee scripts/load_key_point_json_to_db.coffee nceone 121,123,125,127,129
# coffee scripts/load_key_point_json_to_db.coffee de 54,55,56,57,58,59,60


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
    SentenceUtils.importKeyPoints courseName, file
