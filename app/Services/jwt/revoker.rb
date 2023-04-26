module Jwt
  module Revoker
    module_function

    def reset_password(user:)
      user.auth_tokens.delete_all #delete all sessions
    end

    def logout(jti:)
      AuthToken.find_by(jti: jti).delete
    end
  end
end