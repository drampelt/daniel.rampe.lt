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
spritesmith = require 'gulp.spritesmith'
runSequence = require 'run-sequence'
sass = require 'gulp-ruby-sass'

gulp.task 'browserSync', ['coffee', 'js', 'html', 'sass', 'css', 'sprite', 'bower'], ->
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
  sass 'app/styles/main.scss'
    .on 'error', gutil.log
    .pipe gulp.dest '.tmp/styles/'
    .pipe reload stream: true

gulp.task 'sprite', ->
  spriteData = gulp.src 'app/images/*.png'
    .pipe spritesmith
      imgName: 'sprite.png'
      cssName: 'sprite.css'
      cssTemplate: 'sprite.css.handlebars'

  spriteData.img
    .pipe gulp.dest '.tmp/images/'

  spriteData.css
    .pipe gulp.dest '.tmp/styles/'

gulp.task 'serve', ->
  runSequence 'clean', 'browserSync'

gulp.task 'default', ['serve']
