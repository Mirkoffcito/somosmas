# frozen_string_literal: true

require 'swagger_helper'

describe 'Testimonials' do
  path '/api/testimonials' do
    get 'all testimonials' do
      tags 'Testimonials'
      parameter name: :page, in: :query, type: :integer, description: 'Parameter used for paging'

      response '200', 'success status when getting all users (no token required)' do
        run_test!
      end
    end

    post 'creates a testimonial' do
      tags 'Testimonials'
      security [bearer_auth: []]
      consumes 'application/json'
      parameter name: :testimonial, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          content: { type: :string }
        },
        required: %w[name content]
      }

      # response '401', 'client user token, message: You are not an administrator' do
      #   run_test!
      # end

      response '201', 'testimonial created' do
        run_test!
      end

      response '400', 'bad request status if not pass the required parameters or sends some invalid parameter' do
        run_test!
      end

      response '401', 'unauthorized status if you do not have a token or are a client user' do
        run_test!
      end
    end
  end

  path '/api/testimonials/{testimonial_id}' do
    put 'update an existing testimonial' do
      tags 'Testimonials'
      security [bearer_auth: []]
      consumes 'application/json'
      parameter name: :testimonial_id, in: :path, type: :integer
      parameter name: :testimonial, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          content: { type: :string }
        },
        required: %w[name content]
      }

      response '200', 'success status when testimonial updeted' do
        run_test!
      end

      response '401', 'unauthorized status if not have a token or are a client user' do
        run_test!
      end

      response '404', 'not found status if testimonial do not exist ' do
        run_test!
      end

      response '422',
               'unprocessable entity status if not pass the required parameters or sends some invalid parameter' do
        run_test!
      end
    end

    delete 'delete an existing testimonial' do
      tags 'Testimonials'
      security [bearer_auth: []]
      parameter name: :testimonial_id, in: :path, type: :integer

      response '200', 'success status when testimonial deleted' do
        run_test!
      end

      response '401', 'unauthorized status if not have a token or are a client user' do
        run_test!
      end

      response '404', 'not found status if testimonial do not exist ' do
        run_test!
      end
    end
  end
end
