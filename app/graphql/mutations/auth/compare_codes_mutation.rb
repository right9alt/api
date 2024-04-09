module Mutations
  module Auth
    class CompareCodesMutation < BaseMutation
      description 'Compare codes for recovery'

      argument :email, String, required: true
      argument :code, String, required: true

      field :errors, [String], null: true
      field :success, Boolean, null: true

      def resolve(email:, code:)
        return { success: true } if code == Rails.cache.read(reset_code_cache_key(email))

        { errors: ['Codes not eq'] }
      end

      private def reset_code_cache_key(user_email)
        "reset_code_#{user_email}"
      end

    end
  end
end
