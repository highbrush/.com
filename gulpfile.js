var gulp = require('gulp'),
    less = require('gulp-less'),
    coffee = require('gulp-coffee'),
    concat = require('gulp-concat'),
    connect = require('gulp-connect'),
    slim = require('gulp-slim'),
    sourcemaps = require('gulp-sourcemaps');

/**
 * Default Task
 */
gulp.task('default', ['vendor', 'images', 'watch', 'serve']);

/**
 * Start a simple webserver
 */
gulp.task('serve', function () {
  connect.server({
    root : 'public',
    port : 8888,
    livereload : true
  });
});

/**
 * Watchers
 */
gulp.task('watch', ['slim', 'less', 'coffee'], function () {
  gulp.watch(['assets/slim/**/*.slim'], ['slim']);
  gulp.watch(['assets/less/**/*.less'], ['less']);
  gulp.watch(['assets/coffee/**/*.coffee'], ['coffee']);
  gulp.watch(['assets/img/**/*', ['images']]);
});

/**
 * Slim
 */
gulp.task('slim', function () {
  return gulp.src([
      'assets/slim/index.slim',
      'assets/slim/firebase.slim'
    ])
    .pipe(concat('index.html'))
    .pipe(slim())
    .pipe(gulp.dest('public'))
    .pipe(connect.reload());
});

/**
 * LESS
 */
gulp.task('less', function () {
  return gulp.src([
      'assets/less/main.less'
    ])
    .pipe(less())
    .pipe(concat('main.css'))
    .pipe(gulp.dest('public/assets/css'))
    .pipe(connect.reload())
});

/**
 * Coffeescript
 */
gulp.task('coffee', function () {
  return gulp.src([
      'assets/coffee/**/*.coffee'
    ])
    .pipe(coffee({bare : true}))
    .pipe(concat('app.js'))
    .pipe(gulp.dest('public/assets/js'))
    .pipe(connect.reload());
});

/**
 * Images
 */
gulp.task('images', function () {
  return gulp.src(['assets/img/**/*'])
    .pipe(gulp.dest('public/assets/img/'));
});

/**
 * Vendor Files
 */
gulp.task('vendor', function () {
  return gulp.src([
    'node_modules/paper/dist/paper-core.min.js',
    'node_modules/firebase/firebase.js',
    'node_modules/jquery/dist/jquery.min.js',
    'node_modules/jquery/dist/jquery.min.map',
    'node_modules/dat.gui/build/dat.gui.min.js',
    'node_modules/dat.gui/build/dat.gui.js.map',
    'node_modules/jquery.pep.js/src/jquery.pep.js',
    'assets/vendor/lodash.min.js'
  ])
    .pipe(gulp.dest('public/assets/vendor/'));
});
