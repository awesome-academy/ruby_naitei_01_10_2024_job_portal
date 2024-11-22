class Company < ApplicationRecord
  has_one_attached :logo

  has_many :jobs, dependent: :destroy
  has_many :company_reviews, dependent: :destroy
  has_many :company_followers, dependent: :destroy
  has_many :followers, through: :company_followers, source: :user

  # Validations
  validates :name, presence: true,
length: {maximum: Settings.company.name_max_length}
  validates :description,
            length: {maximum: Settings.company.description_max_length},
            allow_blank: true
  validates :website,
            format: {with: URI::DEFAULT_PARSER.make_regexp(%w(http https)),
                     message: I18n.t("errors.messages.invalid_url")},
            allow_blank: true
  validate :logo_format

  private

  def logo_format
    return unless logo.attached?

    check_logo_size
    check_logo_format
  end

  def check_logo_size
    return unless logo.blob.byte_size > Settings.image.max_size.megabytes

    errors.add(:logo, I18n.t("errors.messages.avatar_too_large"))
  end

  def check_logo_format
    acceptable_types = Settings.image.acceptable_types
    return if acceptable_types.include?(logo.blob.content_type)

    errors.add(:logo, I18n.t("errors.messages.invalid_avatar_format"))
  end
end
