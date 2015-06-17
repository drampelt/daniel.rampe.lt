gulp = require 'gulp'
browserSync = require('browser-sync').create()
reload = browserSync.reload
clean = require 'gulp-clean'
coffee = require 'gulp-coffee'
gutil = require 'gulp-util'
wiredep = require('wiredep').stream
bower = require 'gulp-bower'
imagemin = require 'gulp-imagemin'
usemin = require 'gulp-usemin'
runSequence = require 'run-sequence'
sass = require 'gulp-ruby-sass'
compass = require 'gulp-compass'

gulp.task 'browserSync', ['coffee', 'js', 'html', 'sass', 'css', 'images', 'bower'], ->
  browserSync.init server: './.tmp', open: false

  gulp.watch 'app/*.html', ['html']
  gulp.watch 'app/scripts/*.coffee', ['coffee']
  gulp.watch 'app/styles/*.scss', ['sass']

gulp.task 'clean', ->
  gulp.src '.tmp', read: false
    .pipe clean()

gulp.task 'js', ->
  gulp.src 'app/scripts/*.js'
    .pipe gulp.dest '.tmp/scripts/'
    .pipe reload stream: true

gulp.task 'coffee', ->
  gulp.src 'app/scripts/*.coffee'
    .pipe(coffee bare: true).on 'error', gutil.log
    .pipe gulp.dest '.tmp/scripts/'
    .pipe reload stream: true

gulp.task 'bower', ->
  bower()
    .pipe gulp.dest '.tmp/lib'

gulp.task 'html', ->
  gulp.src 'app/*.html'
    .pipe wiredep()
    .pipe gulp.dest '.tmp/'
    .pipe reload stream: true

gulp.task 'css', ->
  gulp.src 'app/styles/*.css'
    .pipe gulp.dest '.tmp/styles/'
    .pipe reload stream: true

gulp.task 'sass', ->
  gulp.src 'app/styles/*.scss'
    .pipe compass(
      config_file: './config.rb'
      css: '.tmp/styles'
      sass: 'app/styles'
    ).on 'error', gutil.log
    .pipe gulp.dest '.tmp/styles/'
    .pipe reload stream: true

gulp.task 'images', ->
  gulp.src 'app/images/*'
    .pipe gulp.dest '.tmp/images/'
    .pipe reload stream: true

gulp.task 'serve', ->
  runSequence 'clean', 'browserSync'

gulp.task 'default', ['serve']
