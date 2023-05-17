# frozen_string_literal: true

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

    def followees
      object.followees
    end

    def followers
      object.followers
    end
  end
end
