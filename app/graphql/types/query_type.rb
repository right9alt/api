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
   
    field :all_posts, [Types::PostType],  "Returns all posts", null: true
    def all_posts
      Post.all
    end
  
  end
end
