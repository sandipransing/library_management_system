# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
#Dave: here's how to set your production method
#Dave: THIS NEEDS TO BE AT THE TOP OF environment.rb or it will break!
ENV['RAILS_ENV'] ||= 'development'
#ENV['RAILS_ENV'] ||= 'test'
#ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.2.2'
#RAILS_GEM_VERSION = '1.2.6'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
#CONFIGURATION : Add all configurations inside yml
CONFIG = YAML.load_file("#{RAILS_ROOT}/config/settings.yml") unless defined?(CONFIG)

Rails::Initializer.run do |config|
  config.action_controller.perform_caching = true

  # Settings in config/environments/* take precedence those specified here
  
  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level 
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper, 
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

#  config.action_controller.session = {
#    :session_key => '_story_session',
#    :secret      => 'bff43011c1d97afd51276a727bc4445fd3677768271593089d212e26630224ed9953da3ce809c0ffaf0622cf',
#  }

  #add the app/sweepers to the load path
  config.load_paths += %W( #{RAILS_ROOT}/app/sweepers )

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
  
  # See Rails::Configuration for more options
end

# Add new inflection rules using the following format 
# (all these examples are active by default):
# Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# Include your application configuration below
# Include your app's configuration here:

#GEM_PATH = "/home/hulihana/.gems"

# Plugins
# acts_as_ferret is a gem, NOT a plugin
#require "acts_as_ferret" # Dave: I think this is causing a 500
#require "acts_as_ferret" # Dave: I think this is causing a 500
#require "rubyzip" # Dave: I think this is causing a 500

ActionMailer::Base.delivery_method = :sendmail
=begin
ActionMailer::Base.smtp_settings = {
  :address => 'bogus',
  :port => 25,
  :domain => 'bogus'
}
=end
# Path where the files will be stored
UPLOAD_PATH = "#{RAILS_ROOT}/uploads"


# Define the helpers that extract the plain-text to be indexed
INDEX_HELPERS = [ # defines helpers
  # Examples:
  { :ext => /rtf$/, :helper => 'unrtf --text %s', :remove_before => /-----------------/ },
  #{ :ext => /pdf$/, :helper => 'java -cp /Applications/PDFBox-0.7.3/lib/PDFBox-0.7.3-dev.jar:/Applications/PDFBox-0.7.3/external/FontBox-0.1.0-dev.jar org.pdfbox.ExtractText %s %s', :file_output => true },
  { :ext => /doc$/, :helper => 'antiword %s', :remove_before => /-----------------/ }
]


