# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApplicationController
      SECRET = 'some random string 123'

      def signup
        user = User.new(user_params)

        if user.save
          render json: {
            data: { login: user.login }
          }
        else
          render json: {
            data: user.errors
          }, status: :unprocessable_entity
        end
      end

      def login
        user = User.find_by(user_params)

        if user
          render json: {
            data: { login: user.login },
            token: user.token
          }, status: :created
        else
          render json: {
            data: { errors: ['login or password were incorrect.'] }
          }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:data).permit(:login, :password)
      end
    end
  end
end
