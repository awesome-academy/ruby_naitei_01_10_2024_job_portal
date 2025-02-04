class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable

  has_one_attached :avatar

  belongs_to :company, optional: true

  has_one :user_profile, dependent: :destroy
  has_many :applications, dependent: :destroy
  has_many :applied_jobs, through: :applications, source: :job
  has_many :company_reviews, dependent: :destroy
  has_many :company_followers, dependent: :destroy
  has_many :followed_companies, through: :company_followers, source: :company
  has_many :notifications, dependent: :destroy
  has_many :user_social_links, dependent: :destroy

  accepts_nested_attributes_for :user_social_links, allow_destroy: true
  accepts_nested_attributes_for :user_profile, reject_if: :all_blank

  delegate :user_projects, to: :user_profile

  enum role: {user: 0, business: 1, admin: 2}

  PERMITTED_PARAMS = [
    :full_name,
    :email,
    :dob,
    :phone,
    :password,
    :password_confirmation,
    :avatar,
    {user_profile_attributes: %i(
      id gender current_address education expected_salary
    )},
    {user_social_links_attributes: %i(id platform url _destroy)}
  ].freeze
  validates :email, presence: true, uniqueness: true,
format: {with: URI::MailTo::EMAIL_REGEXP}
  validates :full_name, presence: true,
length: {maximum: Settings.user.fullname.max_length}
  validates :phone, presence: true, allow_blank: true
  validates :role, presence: true
  validate :avatar_format

  scope :search, lambda {|search|
    return if search.blank?

    where("full_name LIKE ?", "%#{search}%")
  }

  scope :with_role, ->(role){where(role:)}

  scope :sort_by_param, lambda {|sort_by|
    case sort_by
    when "name"
      order(:full_name)
    when "name_desc"
      order(full_name: :desc)
    when "age"
      order(Arel.sql("TIMESTAMPDIFF(YEAR, dob, CURDATE()) ASC"))
    when "age_desc"
      order(Arel.sql("TIMESTAMPDIFF(YEAR, dob, CURDATE()) DESC"))
    else
      order(created_at: :desc)
    end
  }

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
