require 'rails_helper'

RSpec.describe "Activities", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/activities/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/activities/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/activities/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/activities/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/activities/destroy"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /set_activity" do
    it "returns http success" do
      get "/activities/set_activity"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /activity_params" do
    it "returns http success" do
      get "/activities/activity_params"
      expect(response).to have_http_status(:success)
    end
  end

end
