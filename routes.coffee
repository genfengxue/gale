module.exports = (app) ->
  app.use '/api/key_points', require './api/key_point'
  app.use '/api/sentences', require './api/sentence'
  app.use '/admin', require './api/admin'
  app.use '/auth', require './auth'
