var async = require('async');
var _  = require('lodash');
var _s = require('underscore.string');
var random = new (require('./mt').MersenneTwister)()
var assert = require('assert');

/*
 * @param  [String] key textMap中指定的key
 * @param  [Array]  用于替换占位符的参数，可以为空
 * @return [String] 替换结果
 */
function getText(key, params) {
    if (!params) return textMap[key];

    return _s.sprintf.apply(_s, [textMap[key]].concat(params));
}
exports.getText = getText;

/*
 * @param  [Array] array   一个包含对象的数组
 * @param  [Array] columns 需要从对象中拣选出的属性名
 * @return [Array] 数组array的拷贝，其中的对象只包含columns中指定的那些列
 */
function arrayPick(array, columns) {
    return _.map(array, function(element) {
        return _.pick.apply(_, [element].concat(columns));
    });
}
exports.arrayPick = arrayPick;

/*
 * @param  [Array] array   一个包含对象的数组
 * @param  [Array] columns 需要从对象中忽略的属性名
 * @return [Array] 数组array的拷贝，其中的对象不包含columns中指定的那些列
 */
function arrayOmit(array, columns) {
    return _.map(array, function(element) {
        return _.omit.apply(_, [element].concat(columns));
    });
}
exports.arrayOmit = arrayOmit;

/*
 * @return [Integer] 当前的unix timestamp
 */
function time(date) {
    if(date) {
        return new Date(date).getTime() / 1000 | 0;
    } else {
        return new Date().getTime() / 1000 | 0;
    }
}
exports.time = time;

/*
 * @return [Integer] 当前的以毫秒为单位的时间戳
 */
function milliseconds() {
    return new Date().getTime();
}
exports.milliseconds = milliseconds;

/*
 * @param  [String] key 下划线分隔的字符串
 * @return [String] 每个单词首字母大写
 * @example user_card -> UserCard
 */
function convertToCamelCase(key) {
    return _.map(key.split('_'), function(s) {
        return s.charAt(0).toUpperCase() + s.substr(1);
    }).join('');
}
exports.convertToCamelCase = convertToCamelCase;

/*
 * @param  [String] key 每个单词首字母大写
 * @return [String] 下划线分隔
 * @example UserCard -> user_card
 */
function convertToSnakeCase(key) {
    return _.map(key.match(/[A-Z][a-z0-9]*/g), function(s) {
        return s.charAt(0).toLowerCase() + s.substr(1);
    }).join('_');
}
exports.convertToSnakeCase = convertToSnakeCase;

function getModel(key) {
  return new (require('../api/' + key + '/' + key + '.model')[_u.convertToCamelCase(key)]);
}
exports.getModel = getModel;

function getUtils(key) {
  return new (require('../utils/' + key)[_u.convertToCamelCase(key) + 'Utils']);
}
exports.getUtils = getUtils;

function findIndex(array, key) {
  var target = key.toString();
  return _.findIndex(array, function(ele) {
    return ele.toString() === target;
  });
}
exports.findIndex = findIndex;

function union() {
  return _.uniq(_.union.apply(_, arguments), function(value) {
    return value.toString()
  });
}
exports.union = union;

function isEqual(aId, bId) {
  return aId.toString() === bId.toString();
}
exports.isEqual = isEqual;

function contains(ids, target) {
  var targetStr = target.toString();
  for (var i = 0, l = ids.length; i < l; i++) {
    if (ids[i].toString() === targetStr) return true;
  }
  return false;
}
exports.contains = contains;

function escapeRegex(string) {
  return string.replace(/[{}()^$|.\[\]*?+]/g, '\\$&');
}
exports.escapeRegex = escapeRegex;

var ejs = require('ejs');
var fs = require('fs');
function render(path, locals) {
  var fileString = fs.readFileSync(path, {encoding: 'utf-8'});
  return ejs.render(fileString, locals);
}
exports.render = render;
