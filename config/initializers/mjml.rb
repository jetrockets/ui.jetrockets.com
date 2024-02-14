unless Rails.env.development? || Rails.env.test?
  Mjml.setup do |config|
    config.mjml_binary = "/usr/local/node/bin/node /usr/local/node/bin/mjml"
  end
end
