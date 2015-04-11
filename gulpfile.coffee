gulp = require 'gulp'

$ = require('gulp-load-plugins')
  pattern: ['gulp-*', 'main-bower-files', 'uglify-save-license', 'del', 'merge-stream', 'run-sequence']

handleError =
  $.notify.onError
    title: "Gulp Error: <%= error.plugin %>"
    message: "<%= error.name %>: <%= error.toString() %>"

gulp.task 'express:dev', ->
  $.nodemon { script:'./app.coffee', ext:'coffee js', watch:'./', delay:1.5}
  .on 'restart', ->
    console.log 'restarted!'
  gulp.src "./app.coffee"
  .pipe $.wait(1000)
  .pipe $.open('', url:"http://localhost:#{process.env.PORT or 9000}")

gulp.task 'watch', ->
  $.wait(1000)
  gulp.watch [
    "./**/*.coffee"
    "!node_modules/**/*.coffee"
  ]
  , ['coffeelint:server']

gulp.task 'coffeelint:server', ->
  gulp.src [
    "./**/*.coffee",
    "!node_modules/**/*.coffee"
  ]
  .pipe($.coffeelint('./coffeelint.json'))
  .pipe($.coffeelint.reporter())

gulp.task 'serve', ->
  $.runSequence(
    'coffeelint:server'
    'express:dev'
    'watch'
  )

gulp.task 'dev', ['serve']