# frozen_string_literal: true

class ApplicationController < ActionController::API
  def authenticate
    return if current_user

    render json: { errors: ['Login to access this data.'] }
  end

  def current_user
    return @current_user if @current_user

    return unless request&.headers&.[](:token)

    @current_user = User.load_by_token(request.headers[:token])
  end
end
