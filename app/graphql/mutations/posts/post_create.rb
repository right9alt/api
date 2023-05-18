module Mutations
  module Posts
    class PostCreate < BaseMutation
      description "Creates a new post"

      argument :body, String, required: true
      argument :file, ApolloUploadServer::Upload, required: false

      field :post, Types::PostType, null: true
      field :errors, [String], null: true

      def resolve(body:, file: nil)
        post = context[:current_user].posts.new(body: body)

        if file
          # Сохранение файла с использованием Active Storage
          post.image.attach(file)
        end

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
