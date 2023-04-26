module Jwt
  module Encoder
    module_function

    def call(user)
      jti = SecureRandom.hex
      access_token = JWT.encode(
        {
          user_id: user.id,
          jti: jti
        },
        Jwt::Secret.secret,
        'HS256',
        {salt: rand}
      )

      [access_token, jti]
    end
  end
end