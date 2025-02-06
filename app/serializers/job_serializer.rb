class JobSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :experience_level, :work_type,
             :salary_range, :location, :status, :required_skills,
             :created_at, :updated_at

  belongs_to :company
end
