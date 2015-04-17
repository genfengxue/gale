require './common/init'
moment = require 'moment'


console.log [82..100].join ','
#results = _.select [131..143], (num) ->
#  return num % 2
#console.log results.join ','

#write = ->
#  if typeof arguments[0] is 'object'
#    arguments[0] = JSON.stringify arguments[0]
#  Array::unshift.call arguments, new Date().toISOString()
#  console.log Array::join.call arguments, '\t'
#
#write({1: 'xxxxx'})
#auth = require './auth/auth.service'
#console.log auth.signToken 100
#console.log JSON.stringify auth.signToken 100
#_u.getNeedToProcessFiles 'de', 'KeyPoint', (err, files) ->
#  console.log files

#_u.getNeedToProcessFiles 'nceone', 'KeyPoint', (err, files) ->
#  console.log files
#json = require './local_data/key_point_json/Lesson12.txt.json'
#console.log json[12][1]['garden salad'][0].replace /\\n/, '\n'
#console.log moment('2015-03-27 Z').toISOString()
#arr = ['a', 'b', 'c']
#console.log arr['1']
#arr.length = 0
#console.log arr['1']

#_u.getModel 'active_time'
#countWords = require './local_data/count_words/count_words_converted.json'
#numWords = (_.pluck countWords, 'word').length
#totalCount = _.reduce(countWords, (sum, ele) ->
#  return sum + (if ele.count >= 10 then 10 else ele.count)
#, 0)
#console.log numWords
#console.log totalCount

#KeyPoint = _u.getModel 'key_point'
#datas = for value in [1 .. 3]
#  title: "#{value}"
#  text: "这是第#{value}个知识点"
#console.log datas
#KeyPoint.createQ datas
#.then (docs) ->
#  logger.info docs
#, (err) ->
#  logger.info err

#KeyPoint.create datas, (err) ->
#  docs = Array::slice.call arguments, 1
#  logger.info err, docs
