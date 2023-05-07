module Mutations
  module Users
    class FollowMutation < BaseMutation
      description "Follow/unfollow users"

      argument :user_id, ID, required: true

      field :success, Boolean, null: true
      field :errors, [String], null: true

      def resolve(user_id:)
        user = User.find(user_id)

        if context[:current_user].follow(user)
          { success: true}
        else
          { errors: object.errors.full_messages }
        end
      end
    end 
  end
end