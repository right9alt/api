# frozen_string_literal: true

module Mutations
  module Posts
    class PostCreate < BaseMutation
      description "Creates a new post"

      argument :body, String, required: true

      field :post, Types::PostType, null: true
      field :errors, [String], null: true

      def resolve(body:)

        post = context[:current_user].posts.new(body: body)
        if post.save
          ApiSchema.subscriptions.trigger(:post_created, {}, post)
          { post: post}
        else
          { errors: post.errors.full_messages }
        end
      end
    end
  end
end
