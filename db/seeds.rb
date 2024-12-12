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
              is_active: true,
              role: 0)
end

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
      end_date: Faker::Date.backward(days: 30),
      technologies_used: ["Ruby", "React", "JavaScript", "PostgreSQL"].sample(4)
    )
  end

  rand(2..3).times do
    user.user_social_links.create!(
      platform: rand(0..2), 
      url: Faker::Internet.url(host: "socialmedia.com")
    )
  end
end
