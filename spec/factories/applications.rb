FactoryBot.define do
  factory :application do
    user
    job
    status { :pending }

    trait :with_cv do
      after(:build) do |application|
        application.cv_file.attach(
          io: File.open(Rails.root.join("spec", "fixtures", "files", "test_cv.pdf")),
          filename: "test_cv.pdf",
          content_type: "application/pdf"
        )
      end
    end
  end
end
