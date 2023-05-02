module Mutations
  module Posts
    class PostEdit < BaseMutation
      description "Edit post body"

      argument :post_id, ID, required: true
      argument :new_body, String, required: true

      field :post, Types::PostType, null: true
      field :errors, [String], null: true

      def resolve(new_body:, post_id:)
        post = Post.find(post_id)

        if context[:current_user].posts.include?(post)
          if post.update(body: new_body)
            { post: post}
          else
            { errors: post.errors.full_messages }
          end
        else
          { errors: ['Dont have permissions'] }
        end
      end
    end 
  end
end