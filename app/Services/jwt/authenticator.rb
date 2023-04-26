module Jwt
  module Authenticator
    module_function

    def call(headers:, access_token:)
      token = access_token || Jwt::Authenticator.authenticate_header(
        headers
      )
      raise GraphQL::ExecutionError, 'Invalid acce1ss token' unless token.present?

      decoded_token = Jwt::Decoder.decode!(token)
      user = Jwt::Authenticator.authenticate_user_from_token(decoded_token)
      raise GraphQL::ExecutionError, 'Invalid acces3s token' unless user.present?

      [user, decoded_token]
    end
    
    def authenticate_header(headers)
      headers['Authorization']&.split('Bearer ')&.last
    end

    def authenticate_user_from_token(decoded_token)
      raise GraphQL::ExecutionError, 'Invalid access toke2n' unless decoded_token[:user_id].present?

      user = User.find(decoded_token.fetch(:user_id))
      valid = user.auth_tokens.exists?(jti: decoded_token[:jti])

      return user if valid
    end
  end
end