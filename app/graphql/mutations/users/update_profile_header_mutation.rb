module Mutations
  module Users
    class UpdateProfileHeaderMutation < BaseMutation
      description "Update user profile header"

      field :success, Boolean, null: true
      field :errors, [String], null: true
      field :user, Types::UserType, null: false
      
      argument :profile_header, ApolloUploadServer::Upload, required: false

      def resolve(profile_header: nil)
        if profile_header #надо пересмотреть на обработку ошибок
          blob = ActiveStorage::Blob.create_and_upload!(
            io: profile_header,
            filename: profile_header.original_filename,
            content_type: profile_header.content_type
          )
          context[:current_user].profile_header.attach(blob)
          { user: context[:current_user], success: true}
        else
          { errors: object.errors.full_messages }
        end
      end
    end 
  end
end