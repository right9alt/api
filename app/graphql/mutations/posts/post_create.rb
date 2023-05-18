module Mutations
  module Posts
    class PostCreate < BaseMutation
      description "Creates a new post"

      argument :body, String, required: true
      argument :file, ApolloUploadServer::Upload, required: false

      field :post, Types::PostType, null: true
      field :errors, [String], null: true

      def resolve(body:, file: nil)
        if file
          blob = ActiveStorage::Blob.create_and_upload!(
            io: file,
            filename: file.original_filename,
            content_type: file.content_type
          )    
        end
        post = context[:current_user].posts.new(body: body, image: blob)


        if post.save
          ApiSchema.subscriptions.trigger(:post_created, {}, post)
          { post: post }
        else
          { errors: post.errors.full_messages }
        end
      end
    end
  end
end
