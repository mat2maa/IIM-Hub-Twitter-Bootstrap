# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'
 

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

module IIM
  MOVIE_LANGUAGES = ["Eng", "Zho", "Yue", "Ara", "Dan", "Deu", "Ell",	"Spa",	"Spn",	"Fas",	"Fin",	"Cfr",	"Fra",	"Hin",	"Ind",	"Ita",	"Heb",	"Jpn",	"Kor",	"Msa",	"Nld",	"Nor",	"Por",	"Rus",	"Swe", "Tam",	"Tgl", "Tha", "Tur", "Vie"]
end

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')


Rails::Initializer.run do |config|

  #config.time_zone = 'UTC'
	config.time_zone = 'Singapore'

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :secret_key => '_iim_session',
    :secret      => 'asdlkfhlaskhas9du0f9uas09u-230945209r5u$%^TEGHW$%^#$5wfrasdASFGasfgamsldkfjw4pj3901'
  }
	
	#gems that need to be installed
	#bcrypt-ruby
	#ruby-ole
	#spreadsheet
	#ruby-aaws
	#ruby-debug
	#rbrainz
	#hirb
	#rack
	
	#config.gem "binarylogic-searchlogic", :source => "http://gems.github.com"
  config.gem "searchlogic", :version=>"1.6.6"
	config.gem "mysql"
  config.gem "populator"
	config.gem "faker"
  config.gem "authlogic"
  config.gem "settingslogic"
  config.gem "fastercsv"
  config.gem 'formtastic'
  config.gem 'pdfkit'
  config.gem "capybara"
  config.gem "factory_girl", :source => "http://gemcutter.org"

  config.load_paths << "#{RAILS_ROOT}/app/sweepers"
  
  config.cache_store = :mem_cache_store
  config.action_controller.session_store = :mem_cache_store
  
end

require 'rbrainz'
include MusicBrainz
