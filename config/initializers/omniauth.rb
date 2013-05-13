OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET']
  provider :facebook, ENV['330390967090243'], ENV['e9219fdebaee11b16d845cc000d78797']
  #provider :facebook,'330390967090243','e9219fdebaee11b16d845cc000d78797'

end