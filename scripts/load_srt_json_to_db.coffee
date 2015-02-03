require '../common/init'
fs = require 'fs'

Sentence = _u.getModel 'sentence'
dataPath = 'local_data/L01-54-json'

list = process.argv[2]?.split ',' #可以传参数，逗号分隔，不含空格 28,29,32,33

fs.readdir dataPath, (err, files) ->
  needToProcess = []
  if list
    _.each list, (index) ->
      needToProcess.push files[~~index - 1]
  else
    needToProcess = files

  for file in needToProcess
#    console.log file
    createAll file

createAll = (file) ->
  datas = require "../#{dataPath}/#{file}"
  Sentence.createQ datas
  .then (results) ->
    logger.info "success: #{file}"
    console.log results
  , (err) ->
    logger.info "fail: #{file}"
    logger.info err
    process.exit 1

# coffee scripts/load_srt_json_to_db.coffee 28,29,32,33 #2015-02-03
