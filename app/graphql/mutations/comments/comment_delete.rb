module Mutations
  module Comments
    class CommentDelete < BaseMutation
      description "Deleting comment"

      argument :comment_id, ID, required: true

      field :success, Boolean, null: true
      field :errors, [String], null: true

      def resolve(comment_id:)
        comment = Comment.find(comment_id)

        if context[:current_user].comments.include?(comment)
          if comment.destroy
            { success: true}
          else
            { errors: comment.errors.full_messages }
          end
        else
          { errors: ['Dont have permissions'] }
        end
      end
    end
  end
end