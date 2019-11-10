require 'swagger_helper'

RSpec.describe 'sessions', type: :request do

  path '/sessions' do

    post('Authenticate with email and password') do
      consumes 'application/json'
      produces 'application/json'

      parameter name: :credentials, in: :body, schema: {
        type: :object, 
        properties: {
          email: { type: :string, format: :email },
          password: { type: :string },
        },
        required: [:email, :password]
      }        
        
      response(200, 'authentication successful') do
        schema type: :object, properties: {
          token: { type: :string, description: "Token to use for Autentication"},
          required: [:token]
        }
        let(:credentials) do
          { email: ENV['GOB_USERNAME'], password: ENV['GOB_PASSWORD'] }
        end
        run_test!
      end

      response(422, 'authentication failed') do
        schema type: :object, properties: {
          errors: { type: :object, properties: {
            email: { type: :array, items: { type: :string } },
            password: { type: :array, items: { type: :string } }
          }},            
          required: [:token]
        }
        let(:credentials) do
          { email: 'notreallyanuser@example.org', password: 'wrong'}
        end
        run_test!
      end      
    end
  end
end
