express = require("express")
router = express.Router()
passport = require 'passport'
auth = require "./auth.service"

require './configure_passport'

router.post '/local', (req, res, next) ->
  passport.authenticate('local', (err, user, info) ->
    error = err ? info
    if error then return res.status(401).json(error)
    if !user then return res.status(404).json({message: 'Something went wrong, please try again.'})

    token = auth.signToken(user.userNo)
    res.send token: token
  )(req, res, next)


router.get '/', auth.isAuthenticated(), (req, res) ->
  res.send hello: 'world'

module.exports = router
