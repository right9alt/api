require 'rails_helper'


RSpec.describe Mutations::Auth::SignOutMutation, type: :mutation do
  describe '#resolve' do
    let(:email) { 'test3@example.com' }
    let(:password) { 'pok#ad3@D' }
    context 'when valid credentials are provided' do
      let!(:current_user) { create(:user, email: email, password: password) }
      let(:access_token) { Jwt::Issuer.call(current_user) }
      let(:jti) { Jwt::Decoder.decode(access_token)[:jti] }
      let(:context) { { current_user: current_user, decoded_token: { jti: jti } } }
      it 'returns success' do
        query = <<~GQL
        mutation {
          signOut(input:{})
           {
           
            success
          }
        }
        GQL
        result = ApiSchema.execute(query, context: context)
        data = result.dig('data', 'signOut')

        expect(data.dig('success')).to eq(true)
      end
    end

  end
end
