# frozen_string_literal: true

class User < ApplicationRecord
  SECRET = "cp^h^E$ur`M3yW'~dbz,sd-eprxVF5U<"

  validates :login,    presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true

  def token
    crypt = ActiveSupport::MessageEncryptor.new(SECRET)
    crypt.encrypt_and_sign(id)
  end

  def self.load_by_token(t)
    crypt = ActiveSupport::MessageEncryptor.new(SECRET)
    User.find_by(id: crypt.decrypt_and_verify(t))
  rescue ActiveSupport::MessageEncryptor::InvalidMessage
    nil
  end
end
