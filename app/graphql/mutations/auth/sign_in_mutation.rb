module Mutations
  module Auth
    class SignInMutation < BaseMutation
      description "Auth user in app, create a new auth token"

      argument :email, String, required: true
      argument :password, String, required: true

      field :user, Types::UserType, null: true
      field :access_token, String, null: true
      field :errors, [String], null: true

      def resolve(email:, password:)
        user = User.find_by(email: email)

        if user&.authenticate(password)
          access_token = Jwt::Issuer.call(user)
          { user: user, access_token: access_token }
        else
          { errors: ['Invalid email or password'] }
        end
      end
    end
  end
end