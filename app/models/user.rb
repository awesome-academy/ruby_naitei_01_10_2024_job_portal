class User < ApplicationRecord
  has_one_attached :avatar
  has_secure_password

  has_one :user_profile, dependent: :destroy
  has_many :applications, dependent: :destroy
  has_many :applied_jobs, through: :applications, source: :job
  has_many :company_reviews, dependent: :destroy
  has_many :company_followers, dependent: :destroy
  has_many :followed_companies, through: :company_followers, source: :company
  has_many :notifications, dependent: :destroy
  has_many :user_social_links, dependent: :destroy

  enum role: {user: 0, business: 1, admin: 2}

  validates :email, presence: true, uniqueness: true,
format: {with: URI::MailTo::EMAIL_REGEXP}
  validates :full_name, presence: true,
length: {maximum: Settings.user.fullname.max_length}
  validates :phone, presence: true, allow_blank: true
  validates :role, presence: true
  validate :avatar_format

  private

  def avatar_format
    return unless avatar.attached?

    check_avatar_size
    check_avatar_format
  end

  def check_avatar_size
    return unless avatar.blob.byte_size > Settings.image.max_size.megabytes

    errors.add(:avatar, I18n.t("errors.messages.avatar_too_large"))
  end

  def check_avatar_format
    acceptable_types = Settings.image.acceptable_types
    return if acceptable_types.include?(avatar.blob.content_type)

    errors.add(:avatar, I18n.t("errors.messages.invalid_avatar_format"))
  end
end
