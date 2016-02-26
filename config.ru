$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')
require 'condfig'
run Condfig::Api.new
