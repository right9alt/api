module Jwt
  module Decoder
    module_function

    def decode!(access_token)
      decoded = JWT.decode(access_token, Jwt::Secret.secret, true, { algorithm: 'HS256' })[0]
      raise Errors::Jwt::InvalidToken unless decoded.present?

      decoded.symbolize_keys
    end

    def decode(access_token)
      decode!(access_token)
    rescue StandardError
      nil
    end
  end
end
