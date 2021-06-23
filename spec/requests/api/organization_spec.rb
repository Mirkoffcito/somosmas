require 'rails_helper'

RSpec.describe "Test of Organizations Controller", type: :request do

  describe "GET /api/organization/public" do
    let!(:organization) {create(:organization)}

    it "as public user, returns status ok" do
      get ('/api/organization/public')
      expect(response).to have_http_status(:success)
    end

  end

  describe "PATCH /api/organization/public" do
    let!(:organization) {create(:organization)}
    let!(:role) {create(:role)}
    let!(:user) {create(:user)}

    it "as admin, returns status ok" do
      patch ('/api/organization/public')
      login_with_api(user)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /api/organization/public" do
    let!(:organization) {create(:organization)}

    it "as public user, returns status unauthorized" do
      patch ('/api/organization/public')
      expect(response).to have_http_status(:unauthorized)
    end

  end


end