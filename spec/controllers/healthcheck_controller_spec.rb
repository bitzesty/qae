require "rails_helper"

RSpec.describe HealthcheckController, type: :controller do
  describe "GET #index" do
    let(:mock_start_time) { Time.new(2023, 1, 1, 11, 59, 59).to_f }
    let(:mock_end_time) { Time.new(2023, 1, 1, 12, 0, 0).to_f }

    before do
      allow(controller).to receive(:check_database).and_return({ success: true })
      allow(controller).to receive(:check_redis).and_return({ success: true })
      allow(Time).to receive(:current).and_return(mock_end_time)
      allow_any_instance_of(ActionDispatch::Request).to receive(:env) do |req|
        req.instance_variable_get(:@env).merge("rack.request.start_time" => mock_start_time)
      end
    end

    it "returns a success status with correct XML structure" do
      expect(controller).to receive(:check_database).and_return({ success: true })
      expect(controller).to receive(:check_redis).and_return({ success: true })

      get :index

      expect(controller.instance_variable_get(:@status)).to eq("OK")
      expect(controller.instance_variable_get(:@comments)).to be_empty

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq("application/xml; charset=utf-8")

      expect(response.body).to have_selector("pingdom_http_custom_check status > strong", text: "OK")
      expect(response.body).to have_selector("pingdom_http_custom_check response_time > strong", text: "1000.0")
    end

    context "when a check fails" do
      before do
        allow(controller).to receive(:check_redis).and_return({ success: false, message: "Redis connection failed" })
      end

      it "returns an error status with correct XML structure" do
        get :index
        expect(response).to have_http_status(:internal_server_error)
        expect(response.content_type).to eq("application/xml; charset=utf-8")

        expect(response.body).to have_selector("pingdom_http_custom_check status > strong", text: "FALSE")
        expect(response.body).to have_selector("pingdom_http_custom_check response_time > strong", text: "1000.0")

        expect(response.body).to include("Redis check failed: Redis connection failed")
      end
    end
  end
end
