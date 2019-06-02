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
compass = require 'gulp-compass'
minifyHtml = require 'gulp-minify-html'
minifyCss = require 'gulp-minify-css'
uglify = require 'gulp-uglify'
sftp = require 'gulp-sftp'
RevAll = require 'gulp-rev-all'

# Server

gulp.task 'browserSync', ['coffee', 'js', 'html', 'sass', 'css', 'images', 'bower'], ->
  browserSync.init server: './.tmp', open: false

  gulp.watch 'app/*.html', ['html']
  gulp.watch 'app/scripts/*.coffee', ['coffee']
  gulp.watch 'app/styles/*.scss', ['sass']

gulp.task 'clean', ->
  gulp.src '{.tmp,dist,cdn}', read: false
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

# Building

gulp.task 'usemin', ['coffee', 'js', 'html', 'sass', 'css', 'bower', 'distimages'], ->
  revAll = new RevAll dontRenameFile: [/^\/favicon.ico$/g, '.html']
  gulp.src '.tmp/*.html'
    .pipe usemin
      css: [minifyCss(), 'concat']
      html: [minifyHtml empty: true]
      js: [uglify(), 'concat']
    .pipe revAll.revision()
    .pipe gulp.dest 'dist/'

gulp.task 'distimages', ->
  gulp.src 'app/images/*.png'
    .pipe imagemin()
    .pipe gulp.dest 'dist/images/'

# gulp.task 'rev', ->
#   revAll = new RevAll dontRenameFile: [/^\/favicon.ico$/g, '.html']
#   gulp.src 'dist/**/*'
#     .pipe revAll.revision()
#     .pipe sftp require './ssh.json'

gulp.task 'build', ->
  runSequence 'clean', 'usemin'



gulp.task 'default', ['serve']
