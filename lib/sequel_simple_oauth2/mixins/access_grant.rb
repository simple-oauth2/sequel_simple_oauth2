module Sequel
  module Simple
    module OAuth2
      # AccessGrant role mixin for Sequel.
      # Includes all the required API, associations, validations and callbacks.
      module AccessGrant
        extend ActiveSupport::Concern

        included do # rubocop:disable Metrics/BlockLength
          plugin :validation_helpers
          plugin :timestamps, force: true, update_on_create: true

          # Returns associated Client instance.
          #
          # @return [Object] Client instance.
          #
          many_to_one :client, class: ::Simple::OAuth2.config.client_class_name, key: :client_id

          # Returns associated ResourceOwner instance.
          #
          # @return [Object] ResourceOwner instance.
          #
          many_to_one :resource_owner, class: ::Simple::OAuth2.config.resource_owner_class_name, key: :resource_owner_id

          def before_validation
            if new?
              # Generate token
              generate_token

              # Setup lifetime for `#code` value.
              setup_expiration
            end

            super
          end

          # Required fields!
          def validate
            super
            validates_presence %i[token client_id redirect_uri]
            validates_unique %i[token]
          end

          # Searches for AccessGrant record with the specific `#token` value.
          #
          # @param token [#to_s] token value (any object that responds to `#to_s`).
          #
          # @return [Object, nil] AccessGrant object or nil if there is no record with such `#token`.
          #
          def self.by_token(token)
            first(token: token.to_s)
          end

          # Create a new AccessGrant object.
          #
          # @param client [Object] Client instance.
          # @param resource_owner [Object] ResourceOwner instance.
          # @param redirect_uri [String] Redirect URI callback.
          # @param scopes [String] set of scopes.
          #
          # @return [Object] AccessGrant object.
          #
          def self.create_for(client, resource_owner, redirect_uri, scopes = nil)
            create(
              client_id: client.id,
              resource_owner_id: resource_owner.id,
              redirect_uri: redirect_uri,
              scopes: scopes
            )
          end

          private

          # Generate token
          #
          # @return token [String] string object.
          #
          def generate_token
            self.token = ::Simple::OAuth2.config.token_generator.generate
          end

          # Set lifetime for `#code` value during creating a new record.
          #
          # @return clock [Time] time object.
          #
          def setup_expiration
            self.expires_at = Time.now.utc + ::Simple::OAuth2.config.authorization_code_lifetime if expires_at.nil?
          end
        end
      end
    end
  end
end
