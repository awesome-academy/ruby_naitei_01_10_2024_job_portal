class Job < ApplicationRecord
  belongs_to :company
  has_many :applications, dependent: :destroy
  has_many :applicants, through: :applications, source: :user

  enum work_type: {remote: 0, office: 1, hybrid: 2, oversea: 3}
  enum status: {draft: 0, pending: 1, active: 2, closed: 3}

  scope :filter_by_work_type, lambda {|work_types|
    where(work_type: work_types) if work_types.present?
  }

  scope :filter_by_location, lambda {|location|
    where(location:) if location.present?
  }

  scope :filter_others_location, (lambda do
    where.not(location: ["Hà Nội", "Đà Nẵng", "Hồ Chí Minh"])
  end)

  scope :search_by_keyword, lambda {|keyword|
    where(
      "LOWER(jobs.title) LIKE ? OR " \
      "LOWER(jobs.description) LIKE ? OR " \
      "LOWER(companies.name) LIKE ?",
      "%#{keyword.downcase}%", "%#{keyword.downcase}%", "%#{keyword.downcase}%"
    ).joins(:company)
  }
end
