module.exports = function(grunt) {

  grunt.initConfig({
    express: {
      options: {
        opts: ['node_modules/coffee-script/bin/coffee']
      },
      all: {
        options: {
          script: 'app.coffee'
        }
      },
      dev: {
        options: {
          script: 'app.coffee'
        }
      },
      prod: {
        options: {
          script: 'path/to/prod/server.js',
          node_env: 'production'
        }
      },
      test: {
        options: {
          script: 'path/to/test/server.js'
        }
      }
    },
    watch: {
      express: {
        files:  [ '**/*.coffee', 'Gruntfile.js', '**/*.js' ],
        tasks:  [ 'express:all' ],
        options: {
          spawn: false
        }
      },
    }
  });

  grunt.loadNpmTasks('grunt-express-server');
  grunt.loadNpmTasks('grunt-contrib-watch');

  grunt.registerTask('server', ['express:all', 'watch']);

};
