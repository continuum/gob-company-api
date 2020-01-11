require 'swagger_helper'

RSpec.describe 'candidates', type: :request do
  let(:session) do
    Session.where(
      email: ENV['GOB_USERNAME'], password: ENV['GOB_PASSWORD']
    ).first_or_create!
  end
  let(:token) { session.token }

  path '/candidates/search' do
    post('Search candidates') do
      parameter name: :query, in: :query, type: :string

      produces 'application/json'
      security [ token: [] ]

      response(200, 'list of found candidates (only first page)') do
        schema type: :array, items: { '$ref' => '#/definitions/candidate_object' }
        let(:Authorization) { "Bearer #{token}" }
        let(:query) { 'java' }
        run_test!
      end
    end
  end
end
