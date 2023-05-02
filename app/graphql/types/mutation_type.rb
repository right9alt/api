module Types
  class MutationType < Types::BaseObject
    #Posts
    field :post_create, mutation: Mutations::Posts::PostCreate
    field :post_delete, mutation: Mutations::Posts::PostDelete
    field :post_edit, mutation: Mutations::Posts::PostEdit
    #Comments
    field :comment_create, mutation: Mutations::Comments::CommentCreate
    field :comment_delete, mutation: Mutations::Comments::CommentDelete
    field :comment_edit, mutation: Mutations::Comments::CommentEdit
    #Auth
    field :sign_in, mutation: Mutations::Auth::SignInMutation
    field :sign_up, mutation: Mutations::Auth::SignUpMutation
    field :sign_out, mutation: Mutations::Auth::SignOutMutation
    field :reset_password, mutation: Mutations::Auth::ResetPasswordMutation
    
  end
end
