require 'rails_helper'

RSpec.describe 'Members', type: :request do
  let (:valid_params) { attributes_for :member}
  let (:invalid_params) { attributes_for :param_missing_member}
  let (:user) { attributes_for :admin_user }

  describe 'POST /api/members' do

    context 'with validad parameters' do
      before do
        FactoryBot.create(:admin)
        login_with_api(user)
        post '/api/members', headers:{
          'Authorization': json_response[:user][:token]},
          :params => { member: valid_params }
      end
      it 'succesfully created a new member' do
        expect(response).to have_http_status(:ok)
      end
    end

  end

end