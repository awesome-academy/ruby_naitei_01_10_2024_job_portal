class UserProfile < ApplicationRecord
  has_one_attached :cv_file

  belongs_to :user
  has_many :user_projects, dependent: :destroy

  enum gender: {male: 0, female: 1, other: 2}
end
