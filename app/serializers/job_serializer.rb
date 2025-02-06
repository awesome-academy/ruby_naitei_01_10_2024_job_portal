class JobSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :experience_level, :work_type,
             :salary_range, :location, :status, :required_skills,
             :created_at, :updated_at, :company_name

  belongs_to :company

  def company_name
    object.company.name
  end
end
