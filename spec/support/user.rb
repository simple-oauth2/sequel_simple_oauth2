class User < ::Sequel::Model
  include Sequel::Simple::OAuth2::ResourceOwner
end
