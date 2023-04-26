module Mutations
  class SignOutMutation < BaseMutation
    field :success, Boolean, null: false

    def resolve
      if Jwt::Revoker.logout(jti: context[:decoded_token][:jti])
        { success: true }
      else
        raise GraphQL::ExecutionError, 'Invalid access token'
      end
    end
  end
end