require 'swagger_helper'

RSpec.describe '../integration/api/chats', type: :request do

  describe 'Chats API' do
    
    path '/api/chats' do
      
      get 'Get all chats' do
        tags 'New'
        consumes 'application/json'
        produces 'application/json'
      
        response '200', 'List of chats' do
          schema type: :object,
            properties: {
                chats: {
                  type: :array,
                  items:{
                    properties: {
                      id: { type: :integer },
                      created_at: { type: string }
                    }
                  }
                }
            }
          run_test!
        end
      end
