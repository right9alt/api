# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate, unless: -> { exempted_mutation? }

  rescue_from GraphQL::ExecutionError do |error|
    render json: { errors: [{ message: error.message }] }, status: 401
  end

  private

  def authenticate
    current_user, decoded_token = Jwt::Authenticator.call(
      headers: request.headers,
      access_token: params[:access_token] # authenticate from header OR params
    )

    @current_user = current_user
    @decoded_token = decoded_token
  end

  def exempted_mutation?
    params[:query].match?(/\b(signIn|signUp)\b/)
  end
end
