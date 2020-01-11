require 'swagger_helper'

RSpec.describe 'jobs', type: :request do
  before do
    @session = Session.where(
      email: ENV['GOB_USERNAME'], password: ENV['GOB_PASSWORD']
    ).first_or_create!
    @token = @session.token
  end

  path '/jobs/active' do
    get('List active jobs') do
      consumes 'application/json'
      produces 'application/json'
      security [ token: [] ]

      response(200, 'list of active jobs') do
        schema type: :array, items: { '$ref' => '#/definitions/job_iteration_object' }
        let(:Authorization) { "Bearer #{@token}" }
        run_test!
      end
    end
  end

  path '/jobs/closed' do
    get('List active jobs') do
      consumes 'application/json'
      produces 'application/json'
      security [ token: [] ]

      response(200, 'list of closed jobs') do
        schema type: :array, items: { '$ref' => '#/definitions/job_iteration_object' }
        let(:Authorization) { "Bearer #{@token}" }
        run_test!
      end
    end
  end
end
