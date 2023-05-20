module Mutations
  module Users
    class UpdateAvatarMutation < BaseMutation
      description "Update user avatar"

      field :success, Boolean, null: true
      field :errors, [String], null: true
      field :user, Types::UserType, null: false

      argument :avatar, ApolloUploadServer::Upload, required: false

      def resolve(avatar: nil)
        if avatar #надо пересмотреть на обработку ошибок
          blob = ActiveStorage::Blob.create_and_upload!(
            io: avatar,
            filename: avatar.original_filename,
            content_type: avatar.content_type
          )
          context[:current_user].avatar.attach(blob)
          { user: context[:current_user], success: true}
        else
          { errors: object.errors.full_messages }
        end
      end
    end 
  end
end