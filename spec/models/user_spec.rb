# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:login) }

  it { should validate_presence_of(:password) }

  describe 'uniqueness' do
    subject { FactoryBot.create(:user) }
    it { should validate_uniqueness_of(:login).case_insensitive }
  end

  it 'should give correct token and then validate it' do
    u1 = User.create(login: 'login1', password: 'password1')
    User.create(login: 'login2', password: 'password2')

    loaded = User.load_by_token(u1.token)

    expect(loaded).to eq u1
  end
end
