require '../common/init'
passport = require 'passport'
LocalStrategy = require('passport-local').Strategy

passport.use(new LocalStrategy(
  (username, password, done) ->
    console.log username, password
    done null, {_id: username}
))
