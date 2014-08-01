"use strict"

# Source, test and build folders
source_folder = 'source'
demo_folder = 'demo'
export_templates_folder = 'templates'

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
			sourceSass: {
				files: [ source_folder + '/sass/**/*.{scss,sass}' ]
				tasks: [ 'compass:source', 'cssmin' ]
			}
			demoSass: {
				files: [ demo_folder + '/sass/**/*.{scss,sass}' ]
				tasks: [ 'compass:demo' ]
			}
			coffee: {
				files: [ source_folder + '/coffeescript/**/*.coffee' ]
				tasks: [ 'coffee:build', 'uglify' ]
			}
			jade: {
				files: [ source_folder + '/jade/**/*.jade' ]
				tasks: [ 'jade' ]
			}
			jasmine: {
				files: [ source_folder + '/jasmine/*.coffee' ]
				tasks: [ 'coffee:jasmine', 'jasmine:test:build' ]
			}
			javascript: {
				files: [ source_folder + '/javascript/**/*.js' ]
				tasks: [ 'copy:javascript', 'uglify' ]
			}
			images: {
				files: [ source_folder + '/images/**/*.{png,jpg,gif,svg}' ]
				tasks: [ 'copy:images', 'imagemin' ]
			}
		}

		# Connect live server for testing
		connect: {
			target: {
				options: {
					port: 9000
					base: test_folder
				}
			}
		}

		# Coffeescript configuration
		coffee: {
			options: {
				bare: true
			}
			build: {
				expand: true
				cwd: source_folder + '/coffeescript'
				src: [ '**/*.coffee' ]
				dest: test_folder + '/asset/js'
				ext: '.js'
			}
			jasmine: {
				expand: true
				cwd: source_folder + '/jasmine'
				src: [ '*.coffee' ]
				dest: test_folder + '/tests'
				ext: '.spec.js'
			}
		}

		# Sass configuration using compass
		compass: {
			source: {
				options: {
					sassDir: source_folder + '/sass'
					cssDir: export_templates_folder
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
					cwd: source_folder + '/jade'
					src: [ '**/*.jade', '!layout/**/*.jade' ]
					dest: test_folder
					ext: '.html'
				}]
			}
			template: {
				options: {
					data: {
						debug: false
						build: true
					}
					pretty: true
				}
				files: [{
					expand: true
					cwd: source_folder + '/jade'
					src: [ '**/*.jade', '!layout/**/*.jade' ]
					dest: build_folder
					ext: '.html'
				}]
			}
		}

		# Copy static files
		copy: {
			javascript: {
				files: [{
					expand: true
					cwd: source_folder + '/javascript'
					src: [ '**', '!lib/gsap/**' ]
					dest: test_folder + '/asset/js'
				}]
			}
			images: {
				files: [{
					expand: true
					cwd: source_folder + '/images'
					src: [ '**', '!icons/**' ]
					dest: test_folder + '/asset/image'
				}]
			}
			modernizr: {
				files: [{
					src: source_folder + '/javascript/lib/modernizr.min.js'
					dest: build_folder + '/asset/js/modernizr.min.js'
				}]
			}
		}

		# Configure jasmine
		jasmine: {
			test: {
				src: test_folder + '/asset/js/**/*.js'
				options: {
					specs: test_folder + '/tests/*.spec.js'
				}
			}
		}

		# Clean configurations
		clean: {
			icons: [ test_folder + '/asset/image/icons', test_folder + '/asset/css' ]
			init: [ '_SpecRunner.html', test_folder, build_folder ]
		}

		# Minify css
		cssmin: {
			options: {
				keepSpecialComments: 0
			}
			minify: {
				expand: true
				cwd: test_folder + '/asset/css/'
				src: [ '*.css' ]
				dest: build_folder + '/asset/css/'
				ext: '.css'
			}
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
					'build/asset/js/all.js': [
						'!test/asset/js/lib/modernizr.min.js'
						'test/asset/js/lib/**/*.js'
						'test/asset/js/plugins/**/*.js'
						'test/asset/js/default/**/*.js'
					]
				}
			}
		}

		#  Optimize images
		imagemin: {
			dynamic: {
				files: [{
					expand: true
					cwd: test_folder + '/asset/image/'
					src: [ '**/*.{png,jpg,gif,svg}' ]
					dest: build_folder + '/asset/image/'
				}]
			}
		}
	}

	grunt.registerTask 'init', [ 'clean:init', 'jade', 'compass', 'coffee', 'copy', 'imagemin', 'uglify', 'cssmin', 'jasmine:test:build' ]
	grunt.registerTask 'default', [ 'init', 'connect', 'watch' ]