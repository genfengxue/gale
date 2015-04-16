require '../common/init'
fs = require 'fs'

Lesson = _u.getModel 'lesson'
dataPath = 'local_data/lesson_list_json'

list = process.argv[2]?.split ',' #可以传参数，逗号分隔，不含空格 28,29,32,33

fs.readdir dataPath, (err, files) ->
  needToProcess = []
  if list
    _.each list, (index) ->
      needToProcess.push files[~~index - 1]
  else
    needToProcess = files

  for file in needToProcess
    console.log file
    createAll file

createAll = (file) ->
  datas = require "../#{dataPath}/#{file}"
  Lesson.createQ datas
  .then (results) ->
    logger.info _.pluck results, 'lessonNo'
    logger.info "success: #{file}"
#    console.log results
  , (err) ->
    logger.info "fail: #{file}"
    logger.info err

# coffee scripts/load_lesson_list_json_to_db.coffee
