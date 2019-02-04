# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    login { 'logon' }
    password { 'password' }
  end
end
