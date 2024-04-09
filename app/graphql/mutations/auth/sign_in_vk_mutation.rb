module Mutations
  module Auth
    class SignInVkMutation < BaseMutation
      description 'Auth user in app using vk, create a new auth token'

      argument :uid, String, required: true

      field :user, Types::UserType, null: true
      field :access_token, String, null: true
      field :errors, [String], null: true

      def resolve(uid:)
        user = User.find_or_create_by(uid: auth.uid) do |user|
          user.email = auth.info.email
          user.password = Devise.friendly_token[0, 20]
          # Другие поля пользователя, которые вы хотите заполнить из данных vk
        end

        if user
          access_token = Jwt::Issuer.call(user)
          { user:, access_token: }
        else
          { errors: ['Invalid vk auth'] }
        end
      end
    end
  end
end