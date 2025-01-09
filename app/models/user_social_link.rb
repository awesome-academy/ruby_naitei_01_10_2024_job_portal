class UserSocialLink < ApplicationRecord
  belongs_to :user

  enum platform: {linkedin: 0, github: 1, facebook: 2}

  validates :platform, presence: true, inclusion: {in: platforms.keys}
  validates :url, presence: true,
format: {with: URI::DEFAULT_PARSER.make_regexp(%w(http https))}
end
