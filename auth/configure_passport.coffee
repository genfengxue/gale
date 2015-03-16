require '../common/init'
passport = require 'passport'
LocalStrategy = require('passport-local').Strategy
User = _u.getModel 'user'

passport.use(new LocalStrategy(
  usernameField : 'studentNo'
  passwordField : 'password' # this is the virtual field on the model
, (studentNo, password, done) ->
  User.findOneQ studentNo: studentNo
  .then (user) ->
    unless user then return done null, false, { message: 'This studentNo is not registered.' }
    unless user.authenticate password then return done null, false, { message: 'This password is not correct.' }

    return done null, user
  , (err) ->
    done err
))
