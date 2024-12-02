module JobsHelper
  def work_types
    [
      {key: "jobs.filter.remote", value: "0"},
      {key: "jobs.filter.office", value: "1"},
      {key: "jobs.filter.hybrid", value: "2"},
      {key: "jobs.filter.overseas", value: "3"}
    ]
  end
end
