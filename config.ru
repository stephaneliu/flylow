# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
# Have heroku serve compressed version of asset
use Rack::Deflater
run HawaiianAir::Application
