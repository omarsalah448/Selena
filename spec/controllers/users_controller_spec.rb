require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:valid_attributes) do
    {
      name: "John Doe",
      email: "john@example.com",
      password: "password",
      password_confirmation: "password",
      title: "Developer",
      phone_number: "1234567890",
      company_attributes: {
        name: "ACME Inc",
        timezone: "UTC",
        start_day: "monday"
      }
    }
  end

  let(:invalid_attributes) do
    {
      name: "",
      email: "invalid_email",
      password: "short",
      password_confirmation: "mismatch",
      title: "",
      phone_number: "invalid"
    }
  end

  describe "GET #index" do
    it "returns a success response" do
      user = create(:user)
      sign_in user
      get :index
      expect(response).to be_successful
    end

    it "returns all users" do
      user = create(:user, :admin)
      sign_in user
      create_list(:user, 3)
      get :index
      expect(JSON.parse(response.body).size).to eq(4)
    end

    it "returns only users from the same company for non-admin users" do
      company = create(:company)
      user = create(:user, company: company)
      sign_in user
      create_list(:user, 2, company: company)
      create(:user)
      get :index
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe "GET #show" do
    let(:user) { create(:user) }

    before { sign_in user }

    it "returns a success response" do
      get :show, params: { id: user.to_param }
      expect(response).to be_successful
    end

    it "returns the correct user" do
      get :show, params: { id: user.to_param }
      expect(JSON.parse(response.body)["id"]).to eq(user.id)
    end

    it "returns not found for non-existent user" do
      get :show, params: { id: 999 }
      expect(response).to have_http_status(:not_found)
    end

    it "returns forbidden for unauthorized access" do
      other_user = create(:user)
      get :show, params: { id: other_user.to_param }
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new User" do
        expect {
          post :create, params: { user: valid_attributes, device_id: "device123" }
        }.to change(User, :count).by(1)
      end

      it "creates a new Company" do
        expect {
          post :create, params: { user: valid_attributes, device_id: "device123" }
        }.to change(Company, :count).by(1)
      end

      it "renders a JSON response with the new user" do
        post :create, params: { user: valid_attributes, device_id: "device123" }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end

      it "returns a JWT token" do
        post :create, params: { user: valid_attributes, device_id: "device123" }
        expect(JSON.parse(response.body)).to have_key("token")
      end

      it "creates a device token" do
        expect {
          post :create, params: { user: valid_attributes, device_id: "device123" }
        }.to change(DeviceToken, :count).by(1)
      end
    end

    context "with invalid parameters" do
      it "does not create a new User" do
        expect {
          post :create, params: { user: invalid_attributes }
        }.to change(User, :count).by(0)
      end

      it "renders a JSON response with errors" do
        post :create, params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PUT #update" do
    let(:user) { create(:user) }

    before { sign_in user }

    context "with valid parameters" do
      let(:new_attributes) do
        {
          name: "Jane Doe",
          title: "Senior Developer"
        }
      end

      it "updates the requested user" do
        put :update, params: { id: user.to_param, user: new_attributes }
        user.reload
        expect(user.name).to eq("Jane Doe")
        expect(user.title).to eq("Senior Developer")
      end

      it "renders a JSON response with the user" do
        put :update, params: { id: user.to_param, user: new_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors" do
        put :update, params: { id: user.to_param, user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    it "returns forbidden for unauthorized access" do
      other_user = create(:user)
      put :update, params: { id: other_user.to_param, user: { name: "New Name" } }
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "DELETE #destroy" do
    let(:user) { create(:user) }

    before { sign_in user }

    it "destroys the requested user" do
      expect {
        delete :destroy, params: { id: user.to_param }
      }.to change(User, :count).by(-1)
    end

    it "returns a no content response" do
      delete :destroy, params: { id: user.to_param }
      expect(response).to have_http_status(:no_content)
    end

    it "returns forbidden for unauthorized access" do
      other_user = create(:user)
      delete :destroy, params: { id: other_user.to_param }
      expect(response).to have_http_status(:forbidden)
    end
  end
end