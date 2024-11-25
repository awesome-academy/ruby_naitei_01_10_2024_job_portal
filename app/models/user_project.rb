class UserProject < ApplicationRecord
  belongs_to :user_profile

  # Validations
  validates :title, presence: true,
length: {maximum: Settings.user_project.title_max_length}
  validates :description,
            length: {maximum: Settings.user_project.description_max_length},
            allow_blank: true
  validates :technologies_used, presence: true
  validates :start_date, presence: true
  validate :end_date_after_start_date

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    return unless end_date < start_date

    errors.add(:end_date, I18n.t("errors.messages.end_date_after_start_date"))
  end
end
