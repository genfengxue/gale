async = require('async')
_ = require('lodash')
_s = require('underscore.string')
random = new (require('./mt').MersenneTwister)()
assert = require('assert')
Const = require './Const'

###
# @param  [String] key textMap中指定的key
# @param  [Array]  用于替换占位符的参数，可以为空
# @return [String] 替换结果
###

getText = (key, params) ->
  if !params
    return textMap[key]
  _s.sprintf.apply _s, [ textMap[key] ].concat(params)

###
# @param  [Array] array   一个包含对象的数组
# @param  [Array] columns 需要从对象中拣选出的属性名
# @return [Array] 数组array的拷贝，其中的对象只包含columns中指定的那些列
###

arrayPick = (array, columns) ->
  _.map array, (element) ->
    _.pick.apply _, [ element ].concat(columns)

###
# @param  [Array] array   一个包含对象的数组
# @param  [Array] columns 需要从对象中忽略的属性名
# @return [Array] 数组array的拷贝，其中的对象不包含columns中指定的那些列
###

arrayOmit = (array, columns) ->
  _.map array, (element) ->
    _.omit.apply _, [ element ].concat(columns)

###
# @return [Integer] 当前的unix timestamp
###

time = (date) ->
  if date
    new Date(date).getTime() / 1000 | 0
  else
    (new Date).getTime() / 1000 | 0

###
# @return [Integer] 当前的以毫秒为单位的时间戳
###

milliseconds = ->
  (new Date).getTime()

###
# @param  [String] key 下划线分隔的字符串
# @return [String] 每个单词首字母大写
# @example user_card -> UserCard
###

convertToCamelCase = (key) ->
  _.map(key.split('_'), (s) ->
    s.charAt(0).toUpperCase() + s.substr(1)
  ).join ''

###
# @param  [String] key 每个单词首字母大写
# @return [String] 下划线分隔
# @example UserCard -> user_card
###

convertToSnakeCase = (key) ->
  _.map(key.match(/[A-Z][a-z0-9]*/g), (s) ->
    s.charAt(0).toLowerCase() + s.substr(1)
  ).join '_'

getModel = (key) ->
  new (require('../api/' + key + '/' + key + '.model')[_u.convertToCamelCase(key)])

getUtils = (key) ->
  new (require('../utils/' + key)[_u.convertToCamelCase(key) + 'Utils'])

findIndex = (array, key) ->
  target = key.toString()
  _.findIndex array, (ele) ->
    ele.toString() == target

union = ->
  _.uniq _.union.apply(_, arguments), (value) ->
    value.toString()

isEqual = (aId, bId) ->
  aId.toString() == bId.toString()

contains = (ids, target) ->
  targetStr = target.toString()
  i = 0
  l = ids.length
  while i < l
    if ids[i].toString() == targetStr
      return true
    i++
  false

escapeRegex = (string) ->
  string.replace /[{}()^$|.\[\]*?+]/g, '\\$&'

render = (path, locals) ->
  fileString = fs.readFileSync(path, encoding: 'utf-8')
  ejs.render fileString, locals

getNeedToProcessFiles = (courseName, fileType, cb) ->
  if process.argv[3]
    nums = process.argv[3]?.split ','
    files = for num in nums
      _s.sprintf Const.Course[courseName]["#{fileType}FilePattern"], num
    return cb null, files
  else
    dataPath = _s.sprintf Const["#{fileType}JsonPathPattern"], courseName
    fs.readdir "local_data/#{dataPath}", (err, files) ->
      return console.log err if err
      cb null, files


exports.getText = getText
exports.arrayPick = arrayPick
exports.arrayOmit = arrayOmit
exports.time = time
exports.milliseconds = milliseconds
exports.convertToCamelCase = convertToCamelCase
exports.convertToSnakeCase = convertToSnakeCase
exports.getModel = getModel
exports.getUtils = getUtils
exports.findIndex = findIndex
exports.union = union
exports.isEqual = isEqual
exports.contains = contains
exports.escapeRegex = escapeRegex
ejs = require('ejs')
fs = require('fs')
exports.render = render
exports.getNeedToProcessFiles = getNeedToProcessFiles
