# frozen_string_literal: true

module Types
  class MessageType < Types::BaseObject
    field :id, ID, null: false
    field :user, Types::UserType, null: false
    field :room_id, Integer, null: false
    field :body, String
    field :status, Boolean
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def user
      User.find(object.user_id)
    end
  end
end
