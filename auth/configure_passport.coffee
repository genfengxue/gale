require '../common/init'
passport = require 'passport'
LocalStrategy = require('passport-local').Strategy

passport.use(new LocalStrategy(
    usernameField : 'studentNo'
    passwordField : 'password' # this is the virtual field on the model
  , (username, password, done) ->
    console.log username, password
    done null, {studentNo: username}
))
