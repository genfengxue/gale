require '../common/init'
fs = require 'fs'

SentenceUtils = _u.getUtils 'sentence'

# coffee scripts/load_srt_json_to_db.coffee nceone
# coffee scripts/load_srt_json_to_db.coffee de 5

courseName = process.argv[2] or process.exit 1
unless Const.Course[courseName]
  logger.error 'wrong courseName, you should input de or nceone'
  process.exit 1

fileType = 'Sentence'
_u.getNeedToProcessFiles courseName, fileType, (err, needToProcessFiles) ->
  for file in needToProcessFiles
    SentenceUtils.loadSentences courseName, file
