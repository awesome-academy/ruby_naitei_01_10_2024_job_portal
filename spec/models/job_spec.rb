require "rails_helper"

RSpec.describe Job, type: :model do
  describe "associations" do
    it { should belong_to(:company) }
    it { should have_many(:applications).dependent(:destroy) }
    it { should have_many(:applicants).through(:applications).source(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_most(Settings.jobs.title_max_length) }
    it { should validate_presence_of(:description) }
    it { should validate_length_of(:description).is_at_most(Settings.jobs.description_max_length) }
    it { should validate_presence_of(:location) }
    
    it "raises error for invalid status" do
      expect { Job.new(status: "invalid_status") }
        .to raise_error(ArgumentError, "'invalid_status' is not a valid status")
    end

    it "raises error for invalid work_type" do
      expect { Job.new(work_type: "invalid_work_type") }
        .to raise_error(ArgumentError, "'invalid_work_type' is not a valid work_type")
    end
  end

  describe "enums" do
    it { should define_enum_for(:work_type).with_values(Remote: 0, Office: 1, Hybrid: 2, Oversea: 3) }
    it { should define_enum_for(:status).with_values(draft: 0, pending: 1, active: 2, closed: 3) }
  end

  describe "scopes" do
    let!(:job1) { create(:job, title: "Backend Developer", work_type: :Remote, location: "Hanoi", status: :active) }
    let!(:job2) { create(:job, title: "AI Engineer", work_type: :Office, location: "Saigon", status: :pending) }
    let!(:job3) { create(:job, title: "Frontend Developer", work_type: :Hybrid, location: "Hanoi", status: :closed) }

    describe ".filter_by_work_type" do
      it "returns jobs with specified work types" do
        expect(Job.filter_by_work_type(["Remote", "Office"])).to match_array([job1, job2])
      end
    end

    describe ".filter_by_location" do
      it "returns jobs with specified locations" do
        expect(Job.filter_by_location(["Hanoi"])).to match_array([job1, job3])
      end
    end

    describe ".search_by_keyword" do
      it "returns jobs matching the keyword in title, description, or company name" do
        expect(Job.search_by_keyword("Developer")).to include(job1, job3)
      end

      it "returns all jobs when keyword is blank" do
        expect(Job.search_by_keyword(nil)).to match_array([job1, job2, job3])
        expect(Job.search_by_keyword("")).to match_array([job1, job2, job3])
      end
    end

    describe ".related_jobs" do
      it "returns jobs from the same company excluding the given job" do
        company = create(:company)
        job4 = create(:job, company: company)
        job5 = create(:job, company: company)
        expect(Job.related_jobs(job4)).to include(job5)
        expect(Job.related_jobs(job4)).not_to include(job4)
      end
    end

    describe ".pending" do
      it "returns jobs with pending status" do
        expect(Job.pending).to include(job2)
        expect(Job.pending).not_to include(job1, job3)
      end
    end

    describe ".active" do
      it "returns jobs with active status" do
        expect(Job.active).to include(job1)
        expect(Job.active).not_to include(job2, job3)
      end
    end
  end

  describe "soft deletion" do
    it "does not completely delete the record but only marks deleted_at" do
      job = create(:job)
      job.destroy
      expect(Job.find_by(id: job.id)).to be_nil
      expect(Job.with_deleted.find_by(id: job.id)).not_to be_nil
      expect(Job.with_deleted.find_by(id: job.id).deleted_at).not_to be_nil
    end
  end
  
  describe ".filter_by_location" do
    let!(:job_in_other) { create(:job, location: "Somewhere else") }
    let!(:job_in_target) { create(:job, location: Settings.jobs.filter_locations.first) }
  
    it "returns all jobs if nil or empty" do
      expect(Job.filter_by_location(nil)).to eq(Job.all)
      expect(Job.filter_by_location([])).to eq(Job.all)
    end
  
    it "returns jobs outside target when ['others'] is passed (single element case)" do
      expect(Job.filter_by_location(["others"])).to include(job_in_other)
      expect(Job.filter_by_location(["others"])).not_to include(job_in_target)
    end
  
    it "returns the expected result when ['others', 'Hà Nội'] is passed (multiple elements case)" do
      result = Job.filter_by_location(["others", "Hà Nội"])
      expect(result).to include(job_in_other)
    end
  end
  
  describe "ransacker salary" do
    it "returns search result based on salary" do
      job = create(:job, salary_range: "$1000")
      result = Job.ransack(salary_eq: 1000).result
      expect(result).to include(job)
    end
  end
  
  describe "PERMITTED_PARAMS" do
    it "has expected value" do
      expect(Job::PERMITTED_PARAMS).to eq([
        :title,
        :description,
        :experience_level,
        :work_type,
        :salary_range,
        :location,
        :status,
        { required_skills: [:key, :value] }
      ])
    end
  end
end
