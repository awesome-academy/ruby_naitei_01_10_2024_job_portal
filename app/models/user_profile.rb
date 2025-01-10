class UserProfile < ApplicationRecord
  has_one_attached :cv_file

  belongs_to :user
  has_many :user_projects, dependent: :destroy

  enum gender: {male: 0, female: 1, other: 2}

  validates :bio, length: {maximum: Settings.user_profiles.bio_max_length}
  validates :gender, presence: true, inclusion: {in: genders.keys}
  validates :current_address, presence: true,
length: {maximum: Settings.user_profiles.current_address_max_length}
  validates :work_experience, presence: true
  validates :education,
            length: {maximum: Settings.user_profiles.education_max_length}
end
