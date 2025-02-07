require "rails_helper"

RSpec.describe "Api::V1::Jobs", type: :request do
  let!(:company) { create(:company) }
  let!(:jobs) { create_list(:job, 3, company: company) }

  describe "GET /api/v1/jobs" do
    it "trả về danh sách jobs" do
      get "/api/v1/jobs", headers: { "CONTENT_TYPE": "application/json" }
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(3)
    end
  end

  describe "GET /api/v1/jobs/:id" do
    let(:job) { jobs.first }

    it "trả về chi tiết của 1 job" do
      get "/api/v1/jobs/#{job.id}", headers: { "CONTENT_TYPE": "application/json" }
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response["id"]).to eq(job.id)
    end

    context "khi job không tồn tại" do
      it "trả về lỗi not_found" do
        get "/api/v1/jobs/0", headers: { "CONTENT_TYPE": "application/json" }
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
      post "/api/v1/jobs", params: job_params.to_json, headers: { "CONTENT_TYPE": "application/json" }
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
        post "/api/v1/jobs", params: job_params.to_json, headers: { "CONTENT_TYPE": "application/json" }
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
      put "/api/v1/jobs/#{job.id}", params: job_params.to_json, headers: { "CONTENT_TYPE": "application/json" }
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response["title"]).to eq("Updated Title")
    end

    context "khi dữ liệu không hợp lệ" do
      it "trả về lỗi unprocessable_entity khi title không hợp lệ" do
        # Giả sử title không được phép rỗng
        job_params = { job: { title: "" } }
        put "/api/v1/jobs/#{job.id}", params: job_params.to_json, headers: { "CONTENT_TYPE": "application/json" }
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("errors")
      end
    end
  end

  describe "DELETE /api/v1/jobs/:id" do
    let!(:job) { jobs.first }

    it "xóa job thành công" do
      delete "/api/v1/jobs/#{job.id}", headers: { "CONTENT_TYPE": "application/json" }
      expect(response).to have_http_status(:no_content)
      expect(Job.find_by(id: job.id)).to be_nil
    end

    context "khi job không tồn tại" do
      it "trả về lỗi not_found" do
        delete "/api/v1/jobs/0", headers: { "CONTENT_TYPE": "application/json" }
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body) rescue {}
        # Nếu response body không rỗng, kiểm tra có key error
        expect(json_response).to have_key("error") unless json_response.empty?
      end
    end
  end
end 
