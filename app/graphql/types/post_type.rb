include(Rails.application.routes.url_helpers)

module Types
  class PostType < Types::BaseObject
    field :id, ID, null: false
    field :user_id, Integer, null: false
    field :body, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :comments, [Types::CommentType], null: true
    field :image_urls, [String], null: true

    def comments
      object.comments.where(parent_id: nil)
    end

    def image_urls
      object.images.map do |image|
        if image.present?
          rails_blob_path(image, only_path: true)
        end
      end
    end
  end
end