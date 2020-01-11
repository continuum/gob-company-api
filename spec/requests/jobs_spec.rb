require 'swagger_helper'

RSpec.describe 'jobs', type: :request do
  let(:session) do
    Session.where(
      email: ENV['GOB_USERNAME'], password: ENV['GOB_PASSWORD']
    ).first_or_create!
  end
  let(:token) { session.token }
  let(:some_active_job) { session.active_jobs.first}

  path '/jobs/active' do
    get('List active jobs') do
      consumes 'application/json'
      produces 'application/json'
      security [ token: [] ]

      response(200, 'list of active jobs') do
        schema type: :array, items: { '$ref' => '#/definitions/job_iteration_object' }
        let(:Authorization) { "Bearer #{token}" }
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
        let(:Authorization) { "Bearer #{token}" }
        run_test!
      end
    end
  end

  path '/jobs/{slug}/processes/{id}' do
    get('Job detail') do
      consumes 'application/json'
      produces 'application/json'
      security [ token: [] ]
      parameter name: :slug, in: :path, type: :string
      parameter name: :id, in: :path, type: :integer

      response(200, 'details of a job') do
        schema({'$ref' => '#/definitions/job_object'})
        let(:Authorization) { "Bearer #{token}" }
        let(:slug) { some_active_job[:url].split('/')[2] }
        let(:id) { some_active_job[:url].split('/')[4] }
        run_test!
      end
    end
  end
end
