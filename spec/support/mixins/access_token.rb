class AccessToken < ::Sequel::Model
  include Sequel::Simple::OAuth2::AccessToken
end
