require 'swagger_helper'

RSpec.describe 'candidates', type: :request do
  let(:session) do
    Session.where(
      email: ENV['GOB_USERNAME'], password: ENV['GOB_PASSWORD']
    ).first_or_create!
  end
  let(:token) { session.token }
  let(:some_candidate) { session.search_candidates('ruby').first }


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

  path '/candidates/{id}/applications' do
    get('Candidate applications') do
      parameter name: :id, in: :path, type: :string
      produces 'application/json'
      security [ token: [] ]

      response(200, 'list of candidate applications') do
        schema type: :array, items: {
          '$ref' => '#/definitions/candidate_application_object'
        }
        let(:Authorization) { "Bearer #{token}" }
        let(:id) { some_candidate[:id] }
        run_test!
      end
    end
  end
end
