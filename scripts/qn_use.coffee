qn = require 'qn'
fs = require 'fs'
async = require 'async'

client = qn.create(
  accessKey: process.env.accessKey
  secretKey: process.env.secretKey
  bucket: 'windenglish',
  domain: '7u2qm8.com1.z0.glb.clouddn.com',
)

dataPath = "/Users/lutao/Downloads/direct_english_lesson_list"

uploadFile = (fileName, cb) ->
  client.uploadFile "#{dataPath}/#{fileName}", {key: "de#{fileName}"}, (err, result) ->
    return cb err if err
    console.log result
    cb()

fs.readdir dataPath, (err, files) ->
  return console.log err if err
  async.each files, (file, next) ->
    if /.jpg/i.test file
#      console.log file
#      next()
      uploadFile file, next
    else
      next()
  , (err) ->
    console.log err if err

# accessKey=xxxxx secretKey=yyyyy coffee qn_use.coffee
