global._  = require 'lodash'
global._s = require 'underscore.string'
global.config = require 'config'
global.Q = require 'q'

global._u = require './util'

global.logger = require('./logger').logger
global.loggerD = require('./logger').loggerD
global.AsyncClass = require('./AsyncClass').AsyncClass
global.Const = require './Const'
global.ErrCode = require './ErrCode'
