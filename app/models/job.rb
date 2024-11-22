class Job < ApplicationRecord
  belongs_to :company
  has_many :applications, dependent: :destroy
  has_many :applicants, through: :applications, source: :user

  enum work_type: {remote: 0, office: 1, hybrid: 2, oversea: 3}
  enum status: {draft: 0, pending: 1, active: 2, closed: 3}
end
