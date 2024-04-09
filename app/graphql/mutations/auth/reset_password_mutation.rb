module Mutations
  module Auth
    class ResetPasswordMutation < BaseMutation
      description "Set new user password and clear all sessions"

      argument :password, String, required: true
      argument :new_password, String, required: false, default_value: nil
      argument :email, String, required: false, default_value: nil

      field :user, Types::UserType, null: true
      field :access_token, String, null: true
      field :errors, [String], null: true

      def resolve(password:, new_password:, email:)
        if new_password
          if context[:current_user]&.authenticate(password)
            user = context[:current_user]
            if user.update!(password: new_password)
              Jwt::Revoker.reset_password(user: user)
              access_token = Jwt::Issuer.call(user)
              { user:, access_token: }
            else
              { errors: user.errors.full_messages }
            end
          else
            { user:, errors: ['Incorrect password'] }
          end
        elsif email
          user = User.find_by(email:)
          if user.update!(password:)
            Jwt::Revoker.reset_password(user: user)
            access_token = Jwt::Issuer.call(user)
            { user:, access_token: }
          else
            { errors: user.errors.full_messages }
          end
        else
          { errors: ['Incorrect data'] }
        end
      end

    end
  end
end
