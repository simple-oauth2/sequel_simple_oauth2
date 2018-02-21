module Resource
  module GeneratePassword
    DEFAULT_PASSWORD = 'password'

    def generate_password
      @generate_password ||= BCrypt::Password.create(DEFAULT_PASSWORD)
    end
  end
end
