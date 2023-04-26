module Types
  class MutationType < Types::BaseObject
    # TODO: remove me
    field :sign_in, mutation: Mutations::SignInMutation
    field :sign_up, mutation: Mutations::SignUpMutation
    field :sign_out, mutation: Mutations::SignOutMutation
    field :reset_password, mutation: Mutations::ResetPasswordMutation
  end
end
