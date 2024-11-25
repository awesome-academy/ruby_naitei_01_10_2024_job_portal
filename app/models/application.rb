class Application < ApplicationRecord
  belongs_to :job
  belongs_to :user
  has_many :interview_processes, dependent: :destroy

  enum status: {pending: 0, canceled: 1, reviewing: 2, interviewing: 3,
                accepted: 4, rejected: 5}
end
