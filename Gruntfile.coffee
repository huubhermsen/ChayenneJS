"use strict"

# Grunt setup
module.exports = (grunt) ->

	# Load all dependent npm tasks
	require('load-grunt-tasks')(grunt);

	# Init config
	grunt.initConfig {
		# Read package file
		pkg: grunt.file.readJSON 'package.json'
		
		# Configure watch task
		watch: {
			options: {
				livereload: 8000
				spawn: false
			}
			coffee: {
				files: [ 'source/**/*.coffee' ]
				tasks: [ 'coffee', 'uglify' ]
			}
			sass: {
				files: [ 'source/demo_files/sass/**/*.{scss,sass}' ]
				tasks: [ 'compass:demo', 'cssmin' ]
			}
			jade: {
				files: [ 'source/demo_files/jade/**/*.jade' ]
				tasks: [ 'jade' ]
			}
		}

		# Connect live server for testing
		connect: {
			target: {
				options: {
					port: 9000
					base: 'demo'
				}
			}
		}

		# Coffeescript configuration
		coffee: {
			options: {
				bare: true
			}
			compile: {
				files: {
					'chayenne.js': [ 'source/chayenne.coffee' ]
					'demo/asset/js/chayenne.js': [ 'source/chayenne.coffee' ]
					'demo/asset/js/demo.js': [ 'source/demo_files/coffee/demo.coffee' ]
				}
			}
		}

		# Sass configuration using compass
		compass: {
			demo: {
				options: {
					sassDir: 'source/demo_files/sass'
					cssDir: 'demo/asset/css'
					relativeAssets: true
				}
			}
		}

		# Jade configuration
		jade: {
			compile: {
				options: {
					data: {
						debug: true
						livereload: true
					}
					pretty: true
				}
				files: [{
					expand: true
					cwd: 'source/demo_files/jade'
					src: [ '**/*.jade', '!layout/**/*.jade' ]
					dest: 'demo'
					ext: '.html'
				}]
			}
		}

		# Clean demo folder on init
		clean: {
			init: [ 'demo' ]
		}

		# Minify javascript
		uglify: {
			options: {
				mangle: {
					except: [ 'jQuery', 'Modernizr' ]
				}
				compress: {
					drop_console: true
				}
			}
			javascript: {
				files: {
					'chayenne.min.js': [ 'chayenne.js' ]
				}
			}
		}
	}

	grunt.registerTask 'init', [ 'clean:init', 'jade', 'compass', 'coffee', 'uglify' ]
	grunt.registerTask 'default', [ 'init', 'connect', 'watch' ]