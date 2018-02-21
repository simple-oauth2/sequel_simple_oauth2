# rubocop:disable Style/GuardClause
module Sequel
  module Simple
    module OAuth2
      # ResourceOwner role mixin for Sequel.
      # Includes all the required API, associations, validations and callbacks
      module ResourceOwner
        extend ActiveSupport::Concern

        included do # rubocop:disable Metrics/BlockLength
          include BCrypt

          attr_accessor :password_confirmation

          # BCrypt hash function can handle maximum 72 characters, and if we pass
          # password of length more than 72 characters it ignores extra characters.
          # Hence need to put a restriction on password length.
          MAX_PASSWORD_LENGTH_ALLOWED = 72

          plugin :validation_helpers
          plugin :timestamps, force: true, update_on_create: true

          # Required fields!
          def validate
            super
            validates_presence :password
            validates_max_length MAX_PASSWORD_LENGTH_ALLOWED, :password_confirmation, allow_nil: true

            if password_confirmation.present? && password != password_confirmation
              errors.add(:password_confirmation, 'must match with password')
            end
          end

          # Returns resource if the password is correct, otherwise +false+.
          #
          # @param pass [String] Password value.
          #
          # @return [Object, false] ResourceOwner object or false if password is incorrect.
          #
          # @example
          #   user = User.new(password: 'foo')
          #   user.save
          #   user.authenticate('notfoo') # => false
          #   user.authenticate('foo')    # => user
          #
          def authenticate(pass)
            password.is_password?(pass) && self
            # BCrypt::Password.new(encrypted_password).is_password?(pass) && self
          end

          # Returns encrypted password if encrypted_password is not empty.
          #
          # @return [String] Encrypted password.
          #
          # @example
          #   user = User.new
          #   user.password = 'foo'
          #   user.password          #=> "$2a$10$4LEA7r4YmNHtvlAvHhsYAeZmk/xeUVtMTYqwIvYY76EW5GUqDiP4."
          #   user.password == 'foo' #=> true
          #
          def password
            @password ||= BCrypt::Password.new(encrypted_password) if encrypted_password
          end

          # Allows to increase the amount of work required to hash a password as computers get faster.
          # Old passwords will still work fine, but new passwords can keep up with the times.
          # If true returns BCrypt::Engine::MIN_COST otherwise BCrypt::Engine.cost.
          #
          # @example
          #   user = User.new
          #   user.min_cost? #=> false
          #
          def min_cost?
            false
          end

          # Encrypts the password into the encrypted_password attribute, only if the new password is not empty.
          #
          # @param pass [String] Password value.
          #
          # @return [String] Encrypted password.
          #
          # @example
          #   user = User.new
          #   user.password = nil
          #   user.encrypted_password #=> nil
          #   user.password = 'foo'
          #   user.encrypted_password #=> "$2a$10$4LEA7r4YmNHtvlAvHhsYAeZmk/xeUVtMTYqwIvYY76EW5GUqDiP4."
          #
          def password=(pass)
            if pass.present? && pass.length >= MAX_PASSWORD_LENGTH_ALLOWED
              raise(ArgumentError, "Password is longer than #{MAX_PASSWORD_LENGTH_ALLOWED} characters")
            elsif pass.present?
              cost = min_cost? ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
              new_password = BCrypt::Password.create(pass, cost: cost)
            end

            self.encrypted_password = new_password
          end
        end
      end
    end
  end
end
