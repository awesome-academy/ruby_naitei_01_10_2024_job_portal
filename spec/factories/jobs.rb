FactoryBot.define do
  factory :job do
    title { "Test Job" }
    description { "Test job description" }
    experience_level { "Entry level" }
    work_type { Job.work_types.keys.first }
    salary_range { "$50,000 - $70,000" }
    location { "Hà Nội" }
    status { Job.statuses.keys.first }
    required_skills { { "ruby" => "3", "rails" => "2" } }
    association :company
  end
end
