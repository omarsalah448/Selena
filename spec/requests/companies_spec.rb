require "swagger_helper"

RSpec.describe "Companies API", type: :request do
  let(:user) { create(:user) }
  let(:token) { JWT.encode({ user_id: user.id }, Rails.application.secrets.secret_key_base) }
  let(:Authorization) { "Bearer #{token}" }

  path "/companies" do
    get "Retrieves all companies" do
      tags 'Companies'
      produces 'application/json'
      security [ bearerAuth: [] ]

      response "200", "companies found" do
        before do
          create_list(:company, 3)
        end

        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              timezone: { type: :string },
              start_day: { type: :string },
              created_at: { type: :string, format: :date_time },
              updated_at: { type: :string, format: :date_time }
            },
            required: %w[id name timezone start_day created_at updated_at]
          }

        run_test!
      end

      response "401", "unauthorized" do
        let(:Authorization) { 'Bearer invalid_token' }
        run_test!
      end
    end

    post "Creates a company" do
      tags 'Companies'
      consumes 'application/json'
      produces 'application/json'
      security [ bearerAuth: [] ]
      parameter name: :company, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          timezone: { type: :string },
          start_day: { type: :string }
        },
        required: %w[name timezone start_day]
      }

      response "201", "company created" do
        let(:company) { { name: "ACME Inc", timezone: "UTC", start_day: "monday" } }
        
        it "increases the company count" do
          expect { run_test! }.to change(Company, :count).by(1)
        end

        run_test!
      end

      response "422", "invalid request" do
        let(:company) { { name: 'foo' } }
        run_test!
      end

      response "422", "invalid timezone" do
        let(:company) { { name: 'ACME Inc', timezone: 'Invalid', start_day: 'monday' } }
        run_test!
      end

      response "422", "invalid start_day" do
        let(:company) { { name: 'ACME Inc', timezone: 'UTC', start_day: 'invalid_day' } }
        
        it "returns the correct error message" do
          run_test!
          expect(JSON.parse(response.body)["errors"]).to include("Start day is not included in the list")
        end
      end

      response "401", "unauthorized" do
        let(:Authorization) { 'Bearer invalid_token' }
        let(:company) { { name: 'ACME Inc', timezone: 'UTC', start_day: 'monday' } }
        run_test!
      end
    end
  end

  path "/companies/{id}" do
    get "Retrieves a company" do
      tags 'Companies'
      produces 'application/json'
      security [ bearerAuth: [] ]
      parameter name: :id, in: :path, type: :string

      response "200", "company found" do
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            timezone: { type: :string },
            start_day: { type: :string }
          },
          required: %w[id name timezone start_day]

        let(:id) { create(:company).id }
        run_test!
      end

      response "404", "company not found" do
        let(:id) { 'invalid' }
        run_test!
      end

      response "401", "unauthorized" do
        let(:id) { create(:company).id }
        let(:Authorization) { 'Bearer invalid_token' }
        run_test!
      end
    end

    put "Updates a company" do
      tags 'Companies'
      consumes 'application/json'
      produces 'application/json'
      security [ bearerAuth: [] ]
      parameter name: :id, in: :path, type: :string
      parameter name: :company, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          timezone: { type: :string },
          start_day: { type: :string }
        }
      }

      response "200", "company updated" do
        let(:id) { create(:company).id }
        let(:company) { { name: "ACME Corp", timezone: "GMT" } }
        
        it "updates the company attributes" do
          run_test!
          expect(Company.find(id).name).to eq("ACME Corp")
          expect(Company.find(id).timezone).to eq("GMT")
        end
      end

      response "404", "company not found" do
        let(:id) { 'invalid' }
        let(:company) { { name: 'ACME Corp' } }
        run_test!
      end

      response "422", "invalid request" do
        let(:id) { create(:company).id }
        let(:company) { { name: '' } }
        run_test!
      end

      response "422", "invalid timezone" do
        let(:id) { create(:company).id }
        let(:company) { { timezone: 'Invalid' } }
        run_test!
      end

      response "422", "invalid start_day" do
        let(:id) { create(:company).id }
        let(:company) { { start_day: 'invalid_day' } }
        run_test!
      end

      response "401", "unauthorized" do
        let(:id) { create(:company).id }
        let(:company) { { name: 'ACME Corp' } }
        let(:Authorization) { 'Bearer invalid_token' }
        run_test!
      end
    end

    delete "Deletes a company" do
      tags 'Companies'
      produces 'application/json'
      security [ bearerAuth: [] ]
      parameter name: :id, in: :path, type: :string

      response "204", "company deleted" do
        let(:id) { create(:company).id }
        
        it "decreases the company count" do
          expect { run_test! }.to change(Company, :count).by(-1)
        end
      end

      response "404", "company not found" do
        let(:id) { 'invalid' }
        run_test!
      end

      response "401", "unauthorized" do
        let(:id) { create(:company).id }
        let(:Authorization) { 'Bearer invalid_token' }
        run_test!
      end
    end
  end

  # New test for company employees
  path "/companies/{id}/employees" do
    get "Retrieves employees of a company" do
      tags "Companies"
      produces "application/json"
      security [ bearerAuth: [] ]
      parameter name: :id, in: :path, type: :string

      response "200", "employees found" do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              email: { type: :string },
              first_name: { type: :string },
              last_name: { type: :string },
              role: { type: :string }
            },
            required: %w[id email first_name last_name role]
          }

        let(:id) { create(:company).id }
        before do
          create_list(:user, 3, company_id: id)
        end

        run_test!
      end

      response "404", "company not found" do
        let(:id) { "invalid" }
        run_test!
      end

      response "401", "unauthorized" do
        let(:id) { create(:company).id }
        let(:Authorization) { "Bearer invalid_token" }
        run_test!
      end
    end
  end
end