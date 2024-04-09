# frozen_string_literal: true

module Mutations
  module Comments
    class CommentCreate < BaseMutation
      description "Creates a new comment"

      argument :post_id, ID, required: true
      argument :body, String, required: false
      argument :parent_id, ID, required: false

      field :comment, Types::CommentType, null: true
      field :errors, [String], null: true

      def resolve(body:, post_id:, parent_id:)
        post = Post.find(post_id)
        comment = post.comments.new(user_id: context[:current_user].id,
                                    parent_id:, body:)
        if comment.save
          { comment: }
        else
          { errors: comment.errors.full_messages }
        end
      end
    end
  end
end
