$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')
require 'condfig'
require 'dotenv'
Dotenv.load
run Condfig::Api.new
