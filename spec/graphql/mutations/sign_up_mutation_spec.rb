require "rails_helper"

RSpec.describe "mutation login" do
  let!(:user) { create(:user, email: "test1@example.com", password: "pok#ad3@D") }
  
  it "authenticates the account returning a token" do
    query = <<~GQL
    mutation {
      signUp(
        input: {
          email: "test@example.com",
          password: "pok#ad3@D"}
      ) {
        user {
          id
          email
        }
      }
    }
    GQL
    result = ApiSchema.execute(query)
    expect(result.dig("data", "signUp", "user", "email")).to eq("test@example.com")
  end

  it "authenticates the account with errors(invalid pass, email already taken)" do
    query = <<~GQL
    mutation {
      signUp(
        input: {
          email: "test1@example.com",
          password: "notvalidpassword"}
      ) {
        user {
          id
          email
        }
        errors
      }
    }
    GQL
    result = ApiSchema.execute(query)
    expect(result.dig("data", "signUp", "errors")).to eq(["Email has already been taken", "Password is invalid"])
  end

  
end