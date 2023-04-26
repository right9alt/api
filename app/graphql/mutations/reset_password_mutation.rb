module Mutations
  class ResetPasswordMutation < BaseMutation
    argument :password, String, required: true
    argument :new_password, String, required: true

    field :access_token, String, null: true
    field :errors, [String], null: true

    def resolve(password:)
      user = User.update(password: new_password)
      ####TODO
      if user.save
        access_token = Jwt::Issuer.call(user)
        { user: user, access_token: access_token }
      else
        { errors: user.errors.full_messages }
      end
    end
  end
end