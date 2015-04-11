module.exports = (app) ->
  app.use '/api/key_points', require './api/key_point/controller'
  app.use '/api/sentences', require './api/sentence/controller'
  app.use '/api/courses', require './api/course/controller'
  app.use '/api/lessons', require './api/lesson/controller'
  app.use '/api/users', require './api/user/controller'
  app.use '/api/active_times', require './api/active_time/controller'
  app.use '/api/student_questions', require './api/student_question/controller'
  app.use '/admin', require './api/admin/controller'
  app.use '/api/auth', require './auth'

  # frontend stuff
  app.use '/release_notes', require './frontend/release_note'
