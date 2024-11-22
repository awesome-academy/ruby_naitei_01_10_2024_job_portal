class UserSocialLink < ApplicationRecord
  belongs_to :user

  enum platform: {linkedin: 0, github: 1, facebook: 2}
end
