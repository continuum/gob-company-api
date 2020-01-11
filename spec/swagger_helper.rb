require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      swagger: '2.0',
      info: {
        title: 'GoB Company API',
        version: 'v1'
      },
      paths: {},
      securityDefinitions: {
        token: {
          type: :apiKey,
          name: :Authorization,
          in: :header
        }
      },
      definitions: {
        job_iteration_object: {
          type: :object,
          properties: {
            url: { type: :string },
            title: { type: :string },
          },
          required: [:url, :title]
        },

        job_object: {
          type: :object,
          properties: {
            active: { type: :boolean },
            url: { type: :string },
            title: { type: :string },
            min_salary: { type: :integer },
            max_salary: { type: :integer },
            remote: { type: :boolean },
            city: { type: :string },
            country: { type: :string },
            category_name: { type: :string },
            tags: { type: :array, items: { type: :string } },
            perks: { type: :array, items: { type: :string } },
            modality: { type: :string },
            seniority: { type: :string },
            functions: { type: :string },
            functions_headline: { type: :string },
            benefits: { type: :string },
            benefits_headline: { type: :string },
            desirable: { type: :string },
            desirable_headline: { type: :string },
            unpublished: { type: :boolean },
            public_url: { type: :string },
            company_public_url: { type: :string },
            company_name: {
              type: :object,
              properties: {
                name: { type: :string },
                about: { type: :string },
                url: { type: :string },
              }
            },
            phases: { type: :array, items: {'$ref' => '#/definitions/phase_object'}}
          }
        },

        phase_object: {
          type: :object,
          properties: {
            position: { type: :integer },
            title: { type: :string },
            kind: { type: :string },
            job_applications_count: { type: :integer },
            job_applications_url: { type: :string },
          }
        },

        candidate_object: {
          type: :object,
          properties: {
            id: { type: :string },
            firstname: { type: :string },
            name: { type: :string },
            email: { type: :string },
            description: { type: :string, 'x-nullable' => true },
            avatar: { type: :string, 'x-nullable' => true },
            country_name: { type: :string, 'x-nullable' => true},
            linkedin_link: { type: :string, 'x-nullable' => true },
            github_link: { type: :string, 'x-nullable' => true },
            cv_link: { type: :string, 'x-nullable' => true },
            stackoverflow_link: { type: :string, 'x-nullable' => true },
            portfolio_link: { type: :string, 'x-nullable' => true },
            twitter_link: { type: :string, 'x-nullable' => true },
          },
          required: [:id, :name, :email]
        },

        candidate_application_object: {
          type: :object,
          properties: {
            id: { type: :string },
            url: { type: :string },
            job_title: { type: :string },
            phase_title: { type: :string },
            sent_at: { type: :string },
            sent_at_full: { type: :string },
            messages_count: { type: :integer },
            notes_count: { type: :integer },
            discard_reason: { type: :string, 'x-nullable' => true },
          }
        }
      }

    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :yaml
end
