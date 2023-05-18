module Types
  class PostType < Types::BaseObject
    field :id, ID, null: false
    field :user_id, Integer, null: false
    field :body, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :comments, [Types::CommentType], null: true
    field :image_url, String, null: true

    def comments
      object.comments.where(parent_id: nil)
    end

    def image_url
      object.image.attached? ? url_for(object.image) : nil
    end
  end
end
