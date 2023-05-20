module Types
  class SubscriptionType < BaseObject
    field :post_created, Types::PostType, null: false
    field :message_added_to_room, Types::MessageType, null: false do
      argument :room_id, ID, required: true
    end

    def post_created
      object
    end

    def message_added_to_room(room_id:)
      object
    end
  end
end