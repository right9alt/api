module Mutations
  module Auth
    class SignOutMutation < BaseMutation
      description "Delete current user session by token"

      field :success, Boolean, null: true

      def resolve
        if Jwt::Revoker.logout(jti: context[:decoded_token][:jti])
          { success: true }
        else
          { errors: ['Invalid access token'] }
        end
      end
    end
  end
end