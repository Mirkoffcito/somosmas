require 'rails_helper'

RSpec.describe "Slides", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/slides/index"
      expect(response).to have_http_status(:success)
    end
  end

end
