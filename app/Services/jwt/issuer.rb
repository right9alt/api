module Jwt
  module Issuer
    module_function

    def call(user)
      access_token, jti = Jwt::Encoder.call(user)
      user.auth_tokens.create!(jti: jti)

      access_token
    end
  end
end