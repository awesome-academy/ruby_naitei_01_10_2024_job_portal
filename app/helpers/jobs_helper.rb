module JobsHelper
  def work_types
    [
      {key: "jobs.filter.remote", value: "0"},
      {key: "jobs.filter.office", value: "1"},
      {key: "jobs.filter.hybrid", value: "2"},
      {key: "jobs.filter.overseas", value: "3"}
    ]
  end

  def locations
    [
      {key: "jobs.filter.hanoi", value: "Hà Nội"},
      {key: "jobs.filter.danang", value: "Đà Nẵng"},
      {key: "jobs.filter.hcm", value: "Hồ Chí Minh"},
      {key: "jobs.filter.others", value: "others"}
    ]
  end

  def experience_levels
    [
      {key: "jobs.filter.intern", value: "Intern"},
      {key: "jobs.filter.junior", value: "Junior"},
      {key: "jobs.filter.mid_level", value: "Mid-Level"},
      {key: "jobs.filter.senior", value: "Senior"},
      {key: "jobs.filter.lead", value: "Lead"}
    ]
  end

  def salary_range_config
    {
      min: 0,
      max: Settings.jobs.max_salary,
      step: Settings.jobs.salary_filter_step,
      default_min: 0,
      default_max: Settings.jobs.max_salary
    }
  end
end
