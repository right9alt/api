module Mutations
  module Posts
    class PostEdit < BaseMutation
      description "Edit post body"

      argument :post_id, ID, required: true
      argument :new_body, String, required: true
      argument :files, [ApolloUploadServer::Upload], required: false
      argument :deleted_images_ids, [ID], required: false

      field :post, Types::PostType, null: true
      field :errors, [String], null: true

      def resolve(new_body:, post_id:, files: [], deleted_images_ids: [])
        post = Post.find(post_id)
        if post.user_id == context[:current_user].id
          if post.update(body: new_body)
            deleted_images_ids.each do |image_id|
              image = post.images.find(image_id)
              image.purge
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
            post.images.attach(blobs)  
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