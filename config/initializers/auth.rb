module StarterKit
  class AuthConfig < Settingslogic
    source "#{Rails.root}/config/auth.yml"
    namespace Rails.env
    load!
  end
end

OmniAuth.config.logger = Rails.logger
OmniAuth.config.path_prefix = StarterKit::AuthConfig.omniauth.path_prefix

StarterKit::Application.config.middleware.use OmniAuth::Builder do
  StarterKit::AuthConfig.providers.each do |k, v|
    opts = (v.try(:[], 'oauth') || {}).symbolize_keys
    opts.merge!({client_options: {ssl: {ca_file: Rails.root.join('lib/assets/certs/cacert.pem').to_s}}})
    provider k, v['key'], v['secret'], opts
  end
end
