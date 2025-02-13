require "rails_helper"
require "jwt"
require Rails.root.join("lib/json_web_token")

RSpec.describe "Api::V1::Jobs", type: :request do
  let!(:user)    { create(:user, :user) }
  let!(:company) { create(:company) }
  let!(:jobs)    { create_list(:job, 3, company: company, status: :active) }
  let(:token)    { JsonWebToken.encode(user_id: user.id) }
  let(:headers)  { { "CONTENT_TYPE" => "application/json", "Authorization" => "Bearer #{token}" } }

  describe "GET /api/v1/jobs" do
    it "trả về danh sách jobs với thông tin phân trang" do
      get "/api/v1/jobs", headers: headers
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(3)
      expect(response.headers).to include("X-Total-Count", "X-Total-Pages", "X-Current-Page")
    end
  end

  describe "GET /api/v1/jobs/:id" do
    let(:job) { jobs.first }

    it "trả về chi tiết của 1 job" do
      get "/api/v1/jobs/#{job.id}", headers: headers
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response["id"]).to eq(job.id)
    end

    context "khi job không tồn tại" do
      it "trả về lỗi not_found" do
        get "/api/v1/jobs/0", headers: headers
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body) rescue {}
        expect(json_response).to have_key("error")
      end
    end
  end

  describe "POST /api/v1/jobs" do
    it "tạo thành công một job mới" do
      job_params = { 
        job: { 
          title: "New API Job",
          description: "Job description từ API",
          experience_level: "Junior",
          work_type: "Remote",
          salary_range: "$60,000 - $70,000",
          location: "Hà Nội",
          status: "active",
          company_id: company.id,
          required_skills: [{ "key" => "ruby", "value" => "3" }]
        } 
      }
      post "/api/v1/jobs", params: job_params.to_json, headers: headers
      expect(response).to have_http_status(:created)
      json_response = JSON.parse(response.body)
      expect(json_response["title"]).to eq("New API Job")
    end

    context "khi dữ liệu không hợp lệ" do
      it "trả về lỗi unprocessable_entity" do
        # Ví dụ: thiếu trường title (title là bắt buộc)
        job_params = { 
          job: { 
            description: "Job description từ API",
            experience_level: "Junior",
            work_type: "Remote",
            salary_range: "$60,000 - $70,000",
            location: "Hà Nội",
            status: "active",
            company_id: company.id,
            required_skills: [{ "key" => "ruby", "value" => "3" }]
          }
        }
        post "/api/v1/jobs", params: job_params.to_json, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("errors")
      end
    end
  end

  describe "PUT /api/v1/jobs/:id" do
    let(:job) { jobs.first }

    it "cập nhật thông tin job" do
      job_params = { job: { title: "Updated Title" } }
      put "/api/v1/jobs/#{job.id}", params: job_params.to_json, headers: headers
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response["title"]).to eq("Updated Title")
    end

    context "khi dữ liệu không hợp lệ" do
      it "trả về lỗi unprocessable_entity khi title không hợp lệ" do
        # Giả sử title không được phép rỗng
        job_params = { job: { title: "" } }
        put "/api/v1/jobs/#{job.id}", params: job_params.to_json, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("errors")
      end
    end
  end

  describe "DELETE /api/v1/jobs/:id" do
    let!(:job) { jobs.first }

    it "xóa job thành công" do
      delete "/api/v1/jobs/#{job.id}", headers: headers
      expect(response).to have_http_status(:ok)
      expect(Job.find_by(id: job.id)).to be_nil
    end

    context "khi job không tồn tại" do
      it "trả về lỗi not_found" do
        delete "/api/v1/jobs/0", headers: headers
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body) rescue {}
        expect(json_response).to have_key("error") unless json_response.empty?
      end
    end
  end
end 
