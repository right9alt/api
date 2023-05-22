module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.
    field :current_user, Types::UserType, 'Returns current user based on token', null: false 
    def current_user
      context[:current_user]
    end

    field :get_user, Types::UserType, 'Returns user by id', null: false do
      argument :user_id, ID
    end
    def get_user(user_id:)
      User.find(user_id)
    end
   
    field :all_posts, [Types::PostType],  "Returns all posts", null: true
    def all_posts
      Post.all
    end

    field :get_post, Types::PostType, 'Returns post by id', null: false do
      argument :post_id, ID
    end
    def get_post(post_id:)
      Post.find(post_id)
    end

    field :selected_user_posts, [Types::PostType],  "Returns selected user posts", null: true do
      argument :id, ID
    end

    def selected_user_posts(id:)
      User.find(id).posts
    end

    field :chat_rooms, [Types::RoomType], "Return all user rooms", null: true
    def chat_rooms
      context[:current_user].room_members.map {|rm| rm.room }
    end

    field :messages_for_room, [Types::MessageType],  "Returns selected room messages", null: true do
      argument :room_id, ID
    end

    def messages_for_room(room_id:)
      Room.find(room_id).messages
    end


  end
end
