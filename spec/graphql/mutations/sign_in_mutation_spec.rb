require 'rails_helper'


RSpec.describe Mutations::Auth::SignInMutation, type: :mutation do
  describe '#resolve' do
    let(:email) { 'test3@example.com' }
    let(:password) { 'pok#ad3@D' }

    context 'when valid credentials are provided' do
      let!(:user) { create(:user, email: email, password: password) }

      it 'returns the user and access token' do
        query = <<~GQL
          mutation {
            signIn(
              input: {
                email: "test3@example.com",
                password: "pok#ad3@D"}
            ) {
              user {
                id
                email
              }
              accessToken
            }
          }
          GQL

        result = ApiSchema.execute(query)
        data = result.dig('data', 'signIn')

        expect(data.dig('user', 'id')).to eq(user.id.to_s)
        expect(data.dig('user', 'email')).to eq(user.email)
        expect(data.dig('accessToken')).not_to be_nil
        expect(result.dig('errors')).to be_nil
      end
    end

    context 'when invalid credentials are provided' do
      it 'returns the user and access token' do
        query = <<~GQL
          mutation {
            signIn(
              input: {
                email: "test3@example.com",
                password: "wrong_password"}
            ) {
              user {
                id
                email
              }
              accessToken
              errors
            }
          }
          GQL

        result = ApiSchema.execute(query)
        data = result.dig('data', 'signIn')


        expect(data.dig('user')).to be_nil
        expect(data.dig('access_token')).to be_nil
        expect(data.dig('errors')).to eq(["Invalid email or password"])
      end
    end
  end
end
