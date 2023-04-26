module Mutations
  class ResetPasswordMutation < BaseMutation
    argument :password, String, required: true
    argument :new_password, String, required: true

    field :access_token, String, null: true
    field :errors, [String], null: true

    def resolve(password:, new_password:)
      if context[:current_user]&.authenticate(password)
        user = context[:current_user]
        if user.update!(password: new_password)
          Jwt::Revoker.reset_password(user: user)
          access_token = Jwt::Issuer.call(user)
          { user: user, access_token: access_token }
        else
          { errors: user.errors.full_messages }
        end
      else
        { errors: ['Incorrect password'] }
      end
      
    end
  end
end