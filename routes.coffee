module.exports = (app) ->
  app.use '/api/key_points', require './api/key_point'
  app.use '/api/sentences', require './api/sentence'
