Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :google_oauth2, ENV["AIzaSyBr_pPisv3Ued3TRH_bibtKJMINOCFXRaM"], ENV["T9IJAL4XBMh38kQBPxIQuUrX"]       
  provider :facebook, ENV["428675653894511"], ENV["8ab73ee431130fceb58211ca04d4b7c9"]
end
