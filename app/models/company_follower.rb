class CompanyFollower < ApplicationRecord
  belongs_to :company
  belongs_to :user

  validates :user_id,
            uniqueness: {scope: :company_id,
                         message: I18n.t("errors.messages.already_followed")}
end
