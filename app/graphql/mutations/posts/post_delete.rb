module Mutations
  module Posts
    class PostDelete < BaseMutation
      description "Deleting post"

      argument :post_id, ID, required: true

      field :success, Boolean, null: true
      field :errors, [String], null: true

      def resolve(post_id:)
        post = Post.find(post_id)

        if post_.user_id == context[:current_user].id
          if post.destroy
            { success: true}
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