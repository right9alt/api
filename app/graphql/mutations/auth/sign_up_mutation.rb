module Mutations
  module Auth
    class SignUpMutation < BaseMutation
      description "Creating new user account and auth token"

      argument :email, String, required: true
      argument :password, String, required: true

      field :user, Types::UserType, null: true
      field :access_token, String, null: true
      field :errors, [String], null: true

      def resolve(email:, password:)
        user = User.new(email: email, password: password)

        if user.save
          access_token = Jwt::Issuer.call(user)
          { user: user, access_token: access_token }
        else
          { errors: user.errors.full_messages }
        end
      end
    end
  end
end