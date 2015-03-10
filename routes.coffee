module.exports = (app) ->
  app.use '/api/key_points', require './api/key_point/controller'
  app.use '/api/sentences', require './api/sentence/controller'
  app.use '/api/courses', require './api/course/controller'
  app.use '/admin', require './api/admin/controller'
  app.use '/auth', require './auth'
