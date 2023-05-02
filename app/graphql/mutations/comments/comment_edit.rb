module Mutations
  module Comments
    class CommentEdit < BaseMutation
      description "Edit comment"

      argument :comment_id, ID, required: true
      argument :new_body, String, required: true
      
      field :comment, Types::CommentType, null: true
      field :errors, [String], null: true

      def resolve(comment_id:, new_body:)
        comment = Comment.find(comment_id)

        if context[:current_user].comments.include?(comment)
          if comment.update(body: new_body)
            { comment: comment}
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