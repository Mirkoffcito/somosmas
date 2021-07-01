# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe '../integration/api/activities', type: :request do
  describe 'Activities' do
    let!(:create_activities) { create_list(:activity, 10) }
    path '/api/activities' do
      get 'Lists all activities' do
        tags 'activities'
        produces 'application/json'

        response '200', 'lists activities' do
          schema type: :object,
            properties: {
              activities: {
                type: :array,
                items: {
                  properties: {
                    id: { type: :integer },
                    name: { type: :string },
                    content: { type: :string },
                    image: { type: :string }
                  },
                  required: %w[id name content]
                }
              }
            }
          run_test!
        end
      end


      post 'Creates an activity' do
        tags ' Activity creation '
        consumes 'application/json'
        produces 'application/json'

        parameter name: :activity, in: :body, schema: { 
          type: :object,
          properties: {
            activity: {
              type: :object,
              properties: {
                name: { type: :string },
                content: { type: :string },
                image: { type: :string }
              },
              required: %w[name content]
            }
          }
        }

        response '201', 'succesfully' do
          let(:activity) { create(:activity) }
        end
      end
    end
  end
end