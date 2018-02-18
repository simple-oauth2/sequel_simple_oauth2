class Client < ::Sequel::Model
  include Sequel::Simple::OAuth2::Client
end
