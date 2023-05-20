module Mutations
  module Posts
    class PostCreate < BaseMutation
      description "Creates a new post"

      argument :body, String, required: true
      argument :files, [ApolloUploadServer::Upload], required: false

      field :post, Types::PostType, null: true
      field :errors, [String], null: true

      MAXIMUM_IMAGES = 10

      def resolve(body:, files: [])
        if files.length > MAXIMUM_IMAGES
          return { errors: ["Exceeded the maximum number of images. Maximum allowed: #{MAXIMUM_IMAGES}"] }
        end

        blobs = []
        files.each do |file|
          blob = ActiveStorage::Blob.create_and_upload!(
            io: file,
            filename: file.original_filename,
            content_type: file.content_type
          )
          blobs << blob
        end

        post = context[:current_user].posts.new(body: body)
        post.images.attach(blobs)

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