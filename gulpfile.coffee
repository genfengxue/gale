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

# will compile less file in first level. patial files should be placed in second level
gulp.task 'less', ->
  gulp.src 'public/less/*.less'
  .pipe $.less().on('error', handleError)
  .pipe gulp.dest('public/css')

gulp.task 'watch', ->
  $.wait(1000)
  gulp.watch [
    "./**/*.coffee"
    "!node_modules/**/*.coffee"
  ]
  , ['coffeelint:server']

  gulp.watch [
    "public/less/**/*.less"
  ]
  , ['less']

gulp.task 'coffeelint:server', ->
  gulp.src [
    "./**/*.coffee",
    "!node_modules/**/*.coffee"
  ]
  .pipe($.coffeelint('./coffeelint.json'))
  .pipe($.coffeelint.reporter())
  .on 'error', handleError

gulp.task 'serve', ->
  $.runSequence(
    'coffeelint:server'
    'less'
    'express:dev'
    'watch'
  )

gulp.task 'dev', ['serve']
