###*
# Attaches the user object to the request if authenticated
# Otherwise returns 403
###

isAuthenticated = (credentialsRequired) ->
  validateJwt = expressJwt(
    secret: config.secrets.session
    credentialsRequired: credentialsRequired)
  compose().use((req, res, next) ->
    # allow access_token to be passed through query parameter as well
    if req.query and req.query.hasOwnProperty('access_token')
      req.headers.authorization = 'Bearer ' + req.query.access_token
    validateJwt req, res, next
    return
  ).use (req, res, next) ->
    if !req.user
      return next()
    User.findOne {userNo: req.user.userNo}, (err, user) ->
      if err
        return next(err)
      if !user
        return res.send(401)
      req.user = user
      next()
      return
    return

isAdmin = ->
  compose().use(isAuthenticated()).use (req, res, next) ->
    if req.user.role == Const.RoleMap['admin']
      next()
    else
      res.send 403
    return

###*
# Checks if the user role meets the minimum requirements of the route
###

hasRole = (roleRequired) ->
  if !roleRequired
    throw new Error('Required role needs to be set')
  compose().use(isAuthenticated()).use (req, res, next) ->
    if config.userRoles.indexOf(req.user.role) >= config.userRoles.indexOf(roleRequired)
      next()
    else
      res.send 403
    return

###*
# Returns a jwt token signed by the app secret
###

signToken = (userNo) ->
#  jwt.sign {userNo: userNo}, config.secrets.session, expiresInMinutes: config.tokenExpiresInMinutes
  jwt.sign {userNo: userNo}, config.secrets.session

###*
# Set token cookie directly for oAuth strategies
###

setTokenCookie = (req, res, redirect) ->
  if !req.user
    return res.json(404, message: 'Something went wrong, please try again.')
  token = signToken(req.user._id, req.user.role)
  res.cookie 'token', JSON.stringify(token)
  res.redirect redirect or '/'
  return

verifyTokenCookie = ->
  compose().use((req, res, next) ->
    if req.cookies.token
      token = req.cookies.token.replace(/"/g, '')
      jwt.verify token, config.secrets.session, null, (err, user) ->
#        if err
#          return next(err)
        if user
          req.user = user
        next()
        return
    else
      next()
    return
  ).use (req, res, next) ->
    if req.user
      User.findOne {userNo: req.user.userNo}, (err, user) ->
        if err
          return next(err)
        if !user
          return res.send(401)
        req.user = user
        next()
        return
    else
      next()
    return

'use strict'
mongoose = require('mongoose')
passport = require('passport')
#var config = require('../config/environment'); #config 是全局变量
jwt = require('jsonwebtoken')
expressJwt = require('express-jwt')
compose = require('composable-middleware')
User = _u.getModel('user')
exports.isAdmin = isAdmin
exports.isAuthenticated = isAuthenticated
exports.hasRole = hasRole
exports.signToken = signToken
exports.setTokenCookie = setTokenCookie
exports.verifyTokenCookie = verifyTokenCookie
