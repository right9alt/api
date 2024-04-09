module Mutations
  module Auth
    class RecoverPasswordMutation < BaseMutation
      description 'Recover password and send email to user'

      argument :email, String, required: true

      field :errors, [String], null: true
      field :success, Boolean, null: true

      def resolve(email:)
        return { errors: 'User not found' } unless User.exists?(email:)

        user = User.find_by(email:)

        # Генерируем код для сброса пароля
        reset_code = generate_reset_code

        # Сохраняем код в кэш Rails
        Rails.cache.write(reset_code_cache_key(user.email), reset_code, expires_in: 1.hour)

        # Отправляем код на почту пользователю
        UserMailer.with(user:, reset_code:).reset_password_code.deliver_now

        { success: true }
      end

      private def generate_reset_code
        SecureRandom.hex(3).upcase
      end

      private def reset_code_cache_key(user_email)
        "reset_code_#{user_email}"
      end

    end
  end
end
