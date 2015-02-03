require '../common/init'
fs = require 'fs'

dataPath = 'local_data/L01-54-json'
outputDir = 'local_data/L01-54-base'

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
    buildStringFromJson file

buildStringFromJson = (file) ->
  datas = require "../#{dataPath}/#{file}"
  lines = []
  _.each datas, (data) ->
    lines.push data.sentenceNo, data.english + '\n'

  newName = file.replace /.srt.json/, '.txt'

  do (newName) ->
    fs.writeFile "#{outputDir}/#{newName}", (lines.join '\n') + '\n', (err) ->
      if err
        console.log err
        process.exit 1

      console.log "write success: #{newName}"
