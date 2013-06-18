Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '208680748430.apps.googleusercontent.com', 'IV23LlbuVdUHrn-B2mNU6pFF',
            {
             :scope => "userinfo.email,userinfo.profile",
             :approval_prompt => "auto"
            }          
  provider :facebook, '333056896822452', '2eb2eedd2b7e6ed4087c73b7bc9dd768'
  # provider :facebook, ENV["KEY/ID"], ENV["CONSUMER_SECRET"]
end
#OmniAuth.config.on_failure = SessionsController.action(:omniauth_failure)