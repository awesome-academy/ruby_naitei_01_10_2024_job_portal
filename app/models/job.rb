class Job < ApplicationRecord
  PERMITTED_PARAMS = [
    :title,
    :description,
    :experience_level,
    :work_type,
    :salary_range,
    :location,
    :status,
    {required_skills: [:key, :value]}
  ].freeze

  acts_as_paranoid
  belongs_to :company
  has_many :applications, dependent: :destroy
  has_many :applicants, through: :applications, source: :user

  enum work_type: {Remote: 0, Office: 1, Hybrid: 2, Oversea: 3}
  enum status: {draft: 0, pending: 1, active: 2, closed: 3}

  validates :title, presence: true,
length: {maximum: Settings.jobs.title_max_length}
  validates :description, presence: true,
length: {maximum: Settings.jobs.description_max_length}
  validates :location, presence: true
  validates :work_type, inclusion: {in: work_types.keys}
  validates :status, inclusion: {in: statuses.keys}

  ransacker :salary do
    Arel.sql("CAST(REGEXP_REPLACE(salary_range, \"[^0-9]\", \"\") AS UNSIGNED)")
  end

  scope :filter_by_work_type, lambda {|work_types|
    where(work_type: work_types) if work_types.present?
  }

  scope :filter_by_location, lambda {|locations|
    return if locations.blank?

    target_locations = Settings.jobs.filter_locations
    locations = Array(locations)

    if locations.include?("others")
      if locations.size == 1
        where.not(location: target_locations)
      else
        where.not(location: target_locations - locations)
      end
    else
      where(location: locations)
    end
  }

  scope :search_by_keyword, lambda {|keyword|
    return if keyword.blank?

    where(
      "LOWER(jobs.title) LIKE :keyword OR " \
      "LOWER(jobs.description) LIKE :keyword OR " \
      "LOWER(companies.name) LIKE :keyword",
      keyword: "%#{keyword.downcase}%"
    ).joins(:company)
  }

  scope :related_jobs, lambda {|job|
    where.not(id: job.id)
         .where(company_id: job.company_id)
         .limit(Settings.jobs.related_jobs_size)
  }

  scope :pending, ->{where(status: :pending)}
  scope :active, ->{where(status: :active)}

  class << self
    def ransackable_attributes _auth_object = nil
      %w(title description location work_type experience_level salary
created_at)
    end

    def ransackable_associations _auth_object = nil
      %w(company)
    end
  end
end
