Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['208680748430.apps.googleusercontent.com'], ENV['IV23LlbuVdUHrn-B2mNU6pFF']          
  # provider :facebook, ENV["KEY/ID"], ENV["CONSUMER_SECRET"]
end
