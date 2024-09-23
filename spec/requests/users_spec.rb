require "swagger_helper"

RSpec.describe "Users API", type: :request do
  path "/users" do
    post "Creates a user" do
      tags "Users"
      consumes "application/json"
      produces "application/json"
      parameter name: :user_params, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              name: { type: :string },
              email: { type: :string },
              title: { type: :string },
              password: { type: :string },
              password_confirmation: { type: :string },
              phone_number: { type: :string },
              company_attributes: {
                type: :object,
                properties: {
                  name: { type: :string },
                  timezone: { type: :string },
                  start_day: { type: :string }
                }
              }
            },
            required: %w[name email title password password_confirmation phone_number]
          },
          device_id: { type: :string }
        },
        required: %w[user device_id]
      }

      response "201", "user created" do
        let(:user_params) do
          {
            user: {
              name: "Omar Salah",
              email: "omar@trianglz.com",
              title: "BE Intern",
              password: "password",
              password_confirmation: "password",
              phone_number: "01227074807",
              company_attributes: {
                name: "TrianglZ",
                timezone: "Cairo",
                start_day: "sunday"
              }
            },
            device_id: "Android"
          }
        end
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["user"]["name"]).to eq("Omar Salah")
          expect(data["user"]["email"]).to eq("omar@trianglz.com")
          expect(data["user"]["title"]).to eq("BE Intern")
          expect(data["user"]["phone_number"]).to eq("01227074807")
          expect(data["user"]["company"]["name"]).to eq("TrianglZ")
          expect(data["user"]["company"]["timezone"]).to eq("Cairo")
          expect(data["user"]["company"]["start_day"]).to eq("sunday")
          expect(data["token"]).to be_present
        end
      end

      response "422", "invalid request" do
        let(:user_params) { { user: { name: "foo" }, device_id: "Android" } }
        run_test!
      end

      response "422", "email already taken" do
        let!(:existing_user) { create(:user, email: "omar@trianglz.com") }
        let(:user_params) do
          {
            user: {
              name: "Omar Salah",
              email: "omar@trianglz.com",
              title: "BE Intern",
              password: "password",
              password_confirmation: "password",
              phone_number: "01227074807"
            },
            device_id: "Android"
          }
        end
        run_test!
      end

      response "422", "password confirmation doesn't match" do
        let(:user_params) do
          {
            user: {
              name: "Omar Salah",
              email: "omar@trianglz.com",
              title: "BE Intern",
              password: "password",
              password_confirmation: "wrong_password",
              phone_number: "01227074807"
            },
            device_id: "Android"
          }
        end
        run_test!
      end
    end
  end

  path "/users/{id}" do
    get "Retrieves a user" do
      tags "Users"
      produces "application/json"
      security [ bearerAuth: [] ]
      parameter name: :id, in: :path, type: :string
      parameter name: :start_date, in: :query, type: :string, format: :date, required: false
      parameter name: :end_date, in: :query, type: :string, format: :date, required: false

      response "200", "user found" do
        let(:id) { create(:user).id }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["user"]["id"]).to eq(id)
          expect(data["vacations"]).to be_present
        end
      end

      response "404", "user not found" do
        let(:id) { "invalid" }
        run_test!
      end

      response "401", "unauthorized" do
        let(:id) { create(:user).id }
        let(:Authorization) { "invalid_token" }
        run_test!
      end
    end

    put "Updates a user" do
      tags "Users"
      consumes "application/json"
      produces "application/json"
      security [ bearerAuth: [] ]
      parameter name: :id, in: :path, type: :string
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string },
          title: { type: :string },
          phone_number: { type: :string }
        }
      }

      response "200", "user updated" do
        let(:id) { create(:user).id }
        let(:user) { { name: "Jane Doe", title: "Senior Manager", phone_number: "+9876543210" } }
        run_test!
      end

      response "404", "user not found" do
        let(:id) { "invalid" }
        let(:user) { { name: "Jane Doe" } }
        run_test!
      end

      response "422", "invalid request" do
        let(:id) { create(:user).id }
        let(:user) { { name: "" } }
        run_test!
      end

      response "401", "unauthorized" do
        let(:id) { create(:user).id }
        let(:user) { { name: "Jane Doe" } }
        let(:Authorization) { "invalid_token" }
        run_test!
      end
    end

    delete "Deletes a user" do
      tags "Users"
      produces "application/json"
      security [ bearerAuth: [] ]
      parameter name: :id, in: :path, type: :string

      response "204", "user deleted" do
        let(:id) { create(:user).id }
        run_test!
      end

      response "404", "user not found" do
        let(:id) { "invalid" }
        run_test!
      end

      response "401", "unauthorized" do
        let(:id) { create(:user).id }
        let(:Authorization) { "invalid_token" }
        run_test!
      end
    end
  end

  path "/users" do
    get "Lists all users" do
      tags "Users"
      produces "application/json"
      security [ bearerAuth: [] ]
      parameter name: :start_date, in: :query, type: :string, format: :date, required: false
      parameter name: :end_date, in: :query, type: :string, format: :date, required: false

      response "200", "users found" do
        before do
          create_list(:user, 5)
        end

        run_test!
      end

      response "401", "unauthorized" do
        let(:Authorization) { "invalid_token" }
        run_test!
      end
    end
  end
end
