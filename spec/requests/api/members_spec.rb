require 'rails_helper'

RSpec.describe 'Members', type: :request do
  let (:valid_params) { attributes_for :member}
  let (:invalid_params) { attributes_for :param_missing_member}

  describe 'POST /api/members' do

    context 'with validad parameters' do
      it 'succesfully created a new member' do
        expect do
          post '/api/members',
            params: {member: valid_params}, as: :json
        end.to change(Member, :count).by(1)
        expect(response).to have_http_status(:ok)
      end
    end

  end

end