# frozen_string_literal: true
include(Rails.application.routes.url_helpers)
module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :email, String, null: false
    field :name, String
    field :password_digest, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :followers, [Types::UserType], null: true
    field :followees, [Types::UserType], null: true  
    field :avatar_url, String, null: true
    field :profile_header_url, String, null: true

    def followees
      object.followees
    end

    def followers
      object.followers
    end

    def avatar_url
      if object.avatar.present?
        rails_blob_path(object.avatar, only_path: true)
      end
    end

    def profile_header_url
      if object.profile_header.present?
        rails_blob_path(object.profile_header, only_path: true)
      end
    end
  end
end
