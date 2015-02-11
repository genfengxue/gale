require '../common/init'

fs = require 'fs'

Sentence = _u.getModel 'sentence'
KeyPoint = _u.getModel 'key_point'
SentenceUtils = _u.getUtils 'sentence'

dataPath = 'local_data/key_point_json'

list = process.argv[2]?.split ',' #可以传参数，逗号分隔，不含空格 28,29,32,33

fs.readdir dataPath, (err, files) ->
  needToProcess = []
  if list
    _.each list, (index) ->
      needToProcess.push files[~~index - 1]
  else
    needToProcess = files

  for file in needToProcess
    datas = SentenceUtils.importKeyPoints file

# coffee scripts/load_key_point_json_to_db.coffee
