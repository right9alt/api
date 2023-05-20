module Mutations
  module Rooms
    class MessageCreate < BaseMutation
      description "Create Room"

      field :success, Boolean, null: true
      field :errors, [String], null: true
      field :message, Types::MessageType, null: true


      argument :room_id, ID, required: true
      argument :body, String, required: true

      def resolve(room_id:, body:)
        message = Message.new(user_id: context[:current_user].id, room_id: room_id, body: body)
        if message.save
          ApiSchema.subscriptions.trigger(:message_added_to_room, {room_id: room_id}, message)
          {message: message, success: true}
        else
          { errors: message.errors.full_messages }
        end
      end
    end 
  end
end