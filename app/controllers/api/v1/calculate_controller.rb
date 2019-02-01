# frozen_string_literal: true
module Api
  module V1
    class CalculateController < ApplicationController
      before_action :authenticate

      def calculate
        render json: {
          data: Calculator.multiple_calc(calc_params)
        }
      end

      private

      def calc_params
        params.require(:data)["input_arrays"]
      end
    end
  end
end
