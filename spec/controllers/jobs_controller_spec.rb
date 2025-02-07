require "rails_helper"

RSpec.describe JobsController, type: :controller do
  let!(:company) { create(:company) }
  let!(:job) { create(:job, company: company, status: :active) }

  describe "GET #index" do
    it "returns HTTP success" do
      get :index
      expect(response).to be_successful
    end

    it "includes active job in assigned jobs" do
      get :index
      expect(assigns(:jobs)).to include(job)
    end

    context "with filters" do
      it "filters by work_type" do
        get :index, params: { q: { work_type_in: ["Remote"] } }
        expect(response).to be_successful
        expect(assigns(:jobs)).to include(job)
      end
  
      it "filters by location" do
        get :index, params: { q: { location_in: ["Hà Nội"] } }
        expect(response).to be_successful
        expect(assigns(:jobs)).to include(job)
      end
  
      it "searches by keyword" do
        get :index, params: { q: { title_or_description_or_company_name_cont: job.title } }
        expect(response).to be_successful
        expect(assigns(:jobs)).to include(job)
      end
    end
  
    context "with pagination" do
      it "displays the correct number of jobs per page" do
        create_list(:job, 10, company: company, status: :active)
        get :index
        expect(assigns(:jobs).size).to eq(Settings.jobs.page_size)
      end
    end
  end

  describe "GET #show" do
    it "returns HTTP success" do
      get :show, params: { id: job.id }
      expect(response).to be_successful
    end
  
    it "assigns the correct job and its details" do
      get :show, params: { id: job.id }
      expect(assigns(:job)).to eq(job)
      expect(assigns(:job).description).to eq(job.description)
    end
  
    context "when job does not exist" do
      it "assigns nil to @job and redirects to the home page with an error flash message" do
        get :show, params: { id: 0 }
        expect(assigns(:job)).to be_nil
        expect(response).to redirect_to(root_path)
        expect(flash[:danger]).to eq(I18n.t("jobs.job_not_found"))
      end
    end
  
    context "when id parameter is missing" do
      it "assigns nil to @job and redirects to the home page with an error flash message" do
        get :show, params: { id: "" }
        expect(assigns(:job)).to be_nil
        expect(response).to redirect_to(root_path)
        expect(flash[:danger]).to eq(I18n.t("jobs.job_not_found"))
      end
    end
  
    context "when id parameter is invalid (non-numeric)" do
      it "assigns nil to @job and redirects to the home page with an error flash message" do
        get :show, params: { id: "invalid" }
        expect(assigns(:job)).to be_nil
        expect(response).to redirect_to(root_path)
        expect(flash[:danger]).to eq(I18n.t("jobs.job_not_found"))
      end
    end
  
    context "when job exists" do
      it "assigns the correct job with matching id" do
        get :show, params: { id: job.id }
        expect(assigns(:job).id).to eq(job.id)
      end

      it "assigns related jobs" do
        related_job = create(:job, company: company)
        get :show, params: { id: job.id }
        expect(assigns(:related_jobs)).to include(related_job)
      end
    end
  end
end
