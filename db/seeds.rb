10.times do
  company = Company.create!(
    name: Faker::Company.unique.name,
    description: Faker::Lorem.sentence(word_count: 10),
    general_info: {
      founded_year: Faker::Number.between(from: 2000, to: 2023),
      number_of_employees: Faker::Number.between(from: 50, to: 1000)
    },
    website: Faker::Internet.url(host: "example.com"),
    address: Faker::Address.full_address
  )

  # Tạo job cho công ty
  rand(3..5).times do
    job = company.jobs.create!(
      title: Faker::Job.title,
      description: Faker::Lorem.paragraph(sentence_count: 5),
      required_skills: {
        languages: Faker::ProgrammingLanguage.name,
        frameworks: Faker::ProgrammingLanguage.name
      },
      experience_level: %w[Junior Mid-level Senior].sample,
      salary_range: "$#{Faker::Number.between(from: 50_000, to: 150_000)} / year",
      location: ["Hà Nội", "Hồ Chí Minh", "Đà Nẵng", "Thanh Hóa", "Hải Phòng"].sample,
      work_type: Job.work_types.keys.sample,
      status: Job.statuses.keys.sample
    )
  end
end

100.times do |n|
  full_name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  dob = Faker::Date.birthday(min_age: 18, max_age: 65)
  phone = Faker::PhoneNumber.cell_phone
  User.create!(full_name: full_name,
              email: email,
              password: password,
              password_confirmation: password,
              dob: dob,
              phone: phone,
              confirmed_at: Time.current,
              role: 0)
end

jobs = Job.all.limit(5)
users = User.limit(10)

users.each do |user|
  profile = user.user_profile || user.create_user_profile!(
    bio: Faker::Lorem.paragraph(sentence_count: 10),
    gender: [0, 1, 2].sample,
    current_address: Faker::Address.full_address,
    work_experience: Faker::Lorem.paragraph(sentence_count: 2),
    education: Faker::Educator.university,
    skills: ["Ruby", "Rails", "JavaScript", "React", "SQL"].sample(3).map do |skill|
      [skill, Faker::Number.between(from: 1, to: 5).to_s]
    end.to_h,
    expected_salary: "#{rand(50..150)}k USD"
  )

  rand(1..3).times do
    profile.user_projects.create!(
      title: Faker::App.name,
      description: Faker::Lorem.paragraph(sentence_count: 2),
      role: ["Developer", "Team Lead", "Designer"].sample,
      start_date: Faker::Date.backward(days: 365 * 2),
      end_date: Faker::Date.forward(days: 30),
      technologies_used: ["Ruby", "React", "JavaScript", "PostgreSQL"].sample(4)
    )
  end

  rand(2..3).times do
    user.user_social_links.create!(
      platform: rand(0..2), 
      url: Faker::Internet.url(host: "socialmedia.com")
    )
  end

  jobs.each do |job|
    application = Application.create!(
      user_id: user.id,
      job_id: job.id,
      status: Application.statuses.values.sample,
      created_at: Faker::Time.between(from: 2.months.ago, to: 1.week.ago),
      updated_at: Time.now
    )

    rand(1..3).times do |stage_number|
      InterviewProcess.create!(
        application_id: application.id,
        stage_number: stage_number + 1,
        stage_type: InterviewProcess.stage_types.values.sample,
        interview_time: Faker::Time.between(from: 1.week.ago, to: 1.week.from_now),
        interview_location: ["Online", "Head Office", "Branch Office"].sample,
        interview_type: InterviewProcess.interview_types.values.sample,
        interviewer_name: Faker::Name.name,
        status: InterviewProcess.statuses.values.sample,
        feedback: Faker::Lorem.sentence(word_count: 15),
        rating: rand(1..5),
        result: InterviewProcess.results.values.sample,
        created_at: Faker::Time.between(from: 2.months.ago, to: 1.week.ago),
        updated_at: Time.now
      )
    end
  end
end

10.times do |n|
  full_name = Faker::Name.name
  email = "enterprise-#{n+1}@railstutorial.org"
  password = "password"
  dob = Faker::Date.birthday(min_age: 18, max_age: 65)
  phone = Faker::PhoneNumber.cell_phone
  User.create!(full_name: full_name,
              email: email,
              password: password,
              password_confirmation: password,
              dob: dob,
              phone: phone,
              role: 1,
              confirmed_at: Time.current,
              company_id: 1)
end

User.create!(full_name: "Admin",
            email: "admin@admin.com",
            password: "password",
            password_confirmation: "password",
            dob: Faker::Date.birthday(min_age: 18, max_age: 65),
            phone: Faker::PhoneNumber.cell_phone,
            confirmed_at: Time.current,
            role: 2)
