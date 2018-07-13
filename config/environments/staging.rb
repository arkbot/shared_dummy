require_relative 'production.rb'

Rails.application.configure do
  config.serve_static_files = true
  config.assets.compile     = true
end
