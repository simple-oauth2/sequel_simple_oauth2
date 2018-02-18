module Sequel
  module Simple
    module OAuth2
      # Client role mixin for Sequel.
      # Includes all the required API, associations, validations and callbacks.
      module Client
        extend ActiveSupport::Concern

        included do
          plugin :validation_helpers
          plugin :timestamps, force: true, update_on_create: true
          plugin :association_dependencies

          # Returns associated AccessToken array.
          #
          # @return [Array<Object>] AccessToken array.
          #
          one_to_many :access_tokens, class: ::Simple::OAuth2.config.access_token_class_name, key: :client_id
          add_association_dependencies access_tokens: :delete

          # Returns associated AccessGrant array.
          #
          # @return [Array<Object>] AccessGrant array.
          #
          one_to_many :access_grants, class: ::Simple::OAuth2.config.access_grant_class_name, key: :client_id

          def before_validation
            # Generate tokens
            generate_tokens if new?
            super
          end

          # Required fields!
          def validate
            super
            validates_presence %i[key secret]
            validates_unique %i[key secret]
          end

          # Searches for Client record with the specific `#key` value.
          #
          # @param key [#to_s] key value (any object that responds to `#to_s`).
          #
          # @return [Object, nil] Client object or nil if there is no record with such `#key`.
          #
          def self.by_key(key)
            first(key: key.to_s)
          end

          private

          # Generate tokens
          #
          # @return token [String] string object.
          # @return refresh_token [String] string object.
          #
          def generate_tokens
            self.key = ::Simple::OAuth2::UniqToken.generate if key.blank?
            self.secret = ::Simple::OAuth2::UniqToken.generate if secret.blank?
          end
        end
      end
    end
  end
end
