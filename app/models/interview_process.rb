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
  enum result: {pass: 0, fail: 1, pending: 2}
end
