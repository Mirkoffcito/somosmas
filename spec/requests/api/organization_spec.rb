require 'rails_helper'

RSpec.describe "Test of Organizations Controller", type: :request do

  # initialize test data
  let!(:organization) {create(:organization)}

  # Test suite for GET #index
  describe "GET /api/organization/public" do
    before do
      get ('/api/organization/public')
    end

    it "as public user, returns status ok" do
      expect(response).to have_http_status(:success)
    end
  end
  
end