module Types
  class SubscriptionType < BaseObject
    field :post_created, Types::PostType, null: false

    def post_created
      object
    end
  end
end