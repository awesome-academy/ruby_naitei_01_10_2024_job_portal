class InterviewProcess < ApplicationRecord
  belongs_to :application

  enum stage_type: {
    technical_test: 0,
    technical_interview: 1,
    behavioral_interview: 2,
    culture_fit: 3,
    final_interview: 4
  }

  enum interview_type: {online: 0, offline: 1}
  enum status: {scheduled: 0, pending: 1, completed: 2, cancelled: 3,
                rescheduled: 4}
  enum result: {pass: 0, fail: 1, waiting: 2}

  validates :stage_type, presence: true, inclusion: {in: stage_types.keys}
  validates :interview_type, presence: true,
inclusion: {in: interview_types.keys}
  validates :status, presence: true, inclusion: {in: statuses.keys}
  validates :result, presence: true, inclusion: {in: results.keys}
  validates :interviewer_name, presence: true,
length: {maximum: Settings.interview_process.interviewer_name_max_length}
  validates :interview_location, presence: true,
length: {maximum: Settings.interview_process.interview_location_max_length}
  validates :feedback,
            length: {maximum: Settings.interview_process.feedback_max_length}
  validates :rating,
            numericality:
              {only_integer: true,
               greater_than_or_equal_to:
               Settings.interview_process.rating_min_value,
               less_than_or_equal_to:
               Settings.interview_process.rating_max_value}
end
