class User < ApplicationRecord
  has_secure_password validations: false
  has_many :sessions, dependent: :destroy
  has_many :playthroughs, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  enum :role, { standard: 0, admin: 1 }, default: :standard

  validates :email_address, presence: true
  validates :password, presence: true, length: { minimum: 8 }, if: -> { provider.blank? && (new_record? || password.present?) }
  validates :password, confirmation: true, if: -> { password.present? }

  # Finds the user linked to this Google identity by email, creating one on
  # first sign-in, and keeps the linked provider/uid/avatar in sync.
  def self.from_omniauth(auth)
    email = auth.info.email.to_s.strip.downcase
    user = find_by(email_address: email) || new(email_address: email)

    user.provider = auth.provider
    user.uid = auth.uid
    user.name ||= auth.info.name
    user.avatar_url = auth.info.image
    user.save!(validate: false) if user.changed?
    user
  end
end
