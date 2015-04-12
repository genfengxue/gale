require '../common/init'
passport = require 'passport'
LocalStrategy = require('passport-local').Strategy
User = _u.getModel 'user'

passport.use(new LocalStrategy(
  usernameField : 'userNo'
  passwordField : 'password' # this is the virtual field on the model
, (userNo, password, done) ->
  User.findOneQ userNo: userNo
  .then (user) ->
    unless user then return done null, false, {message: 'This userNo is not registered.'}
    unless user.authenticate password then return done null, false, {message: 'This password is not correct.'}

    return done null, user
  , (err) ->
    done err
))
