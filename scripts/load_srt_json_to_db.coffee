require '../common/init'
fs = require 'fs'

Sentence = _u.getModel 'sentence'
dataPath = 'local_data/L01-54-json'

fs.readdir dataPath, (err, files) ->
  for file in files
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
