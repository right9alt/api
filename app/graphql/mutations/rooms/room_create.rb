module Mutations
  module Rooms
    class RoomCreate < BaseMutation
      description "Create Room"

      field :success, Boolean, null: true
      field :errors, [String], null: true
      field :room, Types::RoomType, null: true


      argument :second_member, ID, required: true

      def resolve(second_member:)
        second_user = User.find(second_member)
        room = Room.new(title: second_user.email )

        if room.save
          room.room_members << context[:current_user].room_members.new(room_id: room.id)
          room.room_members << second_user.room_members.new(room_id: room.id)
          {room: room, success: true}
        else
          { errors: room.errors.full_messages }
        end
      end
    end 
  end
end