module Sequel
  module Simple
    module OAuth2
      # ResourceOwner role mixin for Sequel.
      # Includes all the required API, associations, validations and callbacks
      module ResourceOwner
        extend ActiveSupport::Concern

        included do
          plugin :timestamps, force: true, update_on_create: true

          # Searches for ResourceOwner record with the specific params.
          #
          # @param _client [Object] Client instance.
          # @param username [String, #to_s] username value (any object that responds to `#to_s`).
          # @param password [String] password value.
          #
          # @return [Object, nil] ResourceOwner object or nil if there is no record with such params.
          #
          def self.oauth_authenticate(_client, username, password)
            user = find(username: username.to_s)
            user if user && user.encrypted_password == password
          end
        end
      end
    end
  end
end
