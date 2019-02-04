# frozen_string_literal: true

require 'rails_helper'

describe 'User', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:headers) do
    { 'Content-Type' => 'application/json',
      'Accept' => 'application/json',
      'token' => user.token }
  end

  def response
    JSON.parse(body)
  end

  def api_calculate(arr)
    post '/api/calculate',
         params: {
           data: {
             "input_arrays": arr
           }
         }.to_json,
         headers: headers
  end

  it 'can calculate if user is logged in' do
    api_calculate([[1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
                   [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]])

    expect(response['data'])
      .to eq [{ 'minimum' => 1, 'average' => 5.5,
                'median' => 5.5, 'outliers' => [-3.0, 13.0] },
              { 'minimum' => 1, 'average' => 5.5,
                'median' => 5.5, 'outliers' => [-3.0, 13.0] }]
  end

  it 'will not calculate if user is no logged in' do
    headers.delete 'token'

    api_calculate([[1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
                   [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]])

    expect(response['errors']).to eq ['Login to access this data.']
  end

  it 'will not calculate if user uses invalid token' do
    headers[:token] = 'invalid_token'
    api_calculate([[1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
                   [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]])

    expect(response['errors']).to eq ['Login to access this data.']
  end

  it 'returns errors if input is invalid' do
    api_calculate([[:asdfasdfasdf]])

    expect(response['data'])
      .to eq [['Input is invalid.']]
  end
end
