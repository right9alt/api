module Mutations
  module Users
    class LikeMutation < BaseMutation
      description "Like/unlike post/comment"

      argument :object_id, ID, required: true
      argument :object_type, String, required: true

      field :success, Boolean, null: true
      field :errors, [String], null: true

      def resolve(object_id:, object_type:)
        object = Object.const_get(object_type).find(object_id)

        if context[:current_user].like(object)
          { success: true}
        else
          { errors: object.errors.full_messages }
        end
      end
    end 
  end
end