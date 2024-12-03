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
end
