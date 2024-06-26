# frozen_string_literal: true

module Types
  class CommentType < Types::BaseObject
    field :id, ID, null: false
    field :user_id, Integer, null: false
    field :post_id, Integer, null: false
    field :body, String
    field :parent_id, Integer
    field :relation_to, Integer
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :comments, [Types::CommentType], null: true
      def comments
        object.comments
      end
    
  end
end
