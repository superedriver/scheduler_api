require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  before(:each) { request.headers['Content-Type'] = "application/json" }

  def self.returns_401_when_token_not_transmitted(*actions)
    actions.each do |action|
      it "#{action} returns 401 when token not transmitted" do
        user = create(:user)
        verb = if action == :update
          "PATCH"
        elsif action == :destroy
          "DELETE"
        else
          "GET"
        end

        process action, verb, id: user.id
        expect(response).to have_http_status(401)
        expect(response.body).to eq(I18n.t("errors.user.non_authorized"))
      end
    end
  end

  returns_401_when_token_not_transmitted :index, :show, :update, :destroy

  describe "GET #index" do
    it "return users if they exist" do
      user1 = create(:user)
      user2 = create(:user)
      request.headers["Authorization"] = "Token token=#{user1.api_key}"
      get :index

      body = JSON.parse(response.body)

      expect(body.length).to eql(2)
      expect(body[0]["email"]).to eq(user1.email)
      expect(body[1]["email"]).to eq(user2.email)
    end
  end

  describe "GET #show" do
    it "return user if user exist" do
      user = create(:user)
      request.headers["Authorization"] = "Token token=#{user.api_key}"
      get :show, params: {id: user.id}

      body = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(body["email"]).to eq(user.email)
    end

    it "return 404 if user not exist" do
      user = create(:user)
      request.headers["Authorization"] = "Token token=#{user.api_key}"
      get :show, params: {id: 0}

      expect(response).to have_http_status(404)
      expect(response.body).to eq(I18n.t("errors.user.not_found"))
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new User" do
        user = build(:user)

        expect {
          post :create, params: {
            name: user.name,
            email: user.email
          }
        }.to change(User, :count).by(1)
      end

      it "returns created user after creation" do
        user = build(:user)
        post :create, params: {
          name: user.name,
          email: user.email
        }
        body = JSON.parse(response.body)

        expect(body["email"]).to eq(user.email)
        expect(body["name"]).to eq(user.name)
      end
    end

    context "with invalid params" do
      it "non-unique email" do
        user1 = create(:user)

        post :create, params: {
          name: user1.name,
          email: user1.email
        }
        body = JSON.parse(response.body)

        expect(body["email"][0]).to eq(
          I18n.t("activerecord.errors.models.user.attributes.email.taken")
        )
      end

      it "blank email" do
        post :create, params: {
          name: "John Doe"
        }
        body = JSON.parse(response.body)

        expect(body["email"][0]).to eq(
          I18n.t("activerecord.errors.models.user.attributes.email.blank")
        )
      end

      it "invalid email format" do
        post :create, params: {
          name: "John Doe",
          email: "email"
        }
        body = JSON.parse(response.body)

        expect(body["email"][0]).to eq(
          I18n.t("activerecord.errors.models.user.attributes.email.invalid")
        )
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      it "updates the requested user" do
        new_name = "New Name"
        user = create(:user)
        request.headers["Authorization"] = "Token token=#{user.api_key}"
        put :update, params: {
            id: user.id,
            name: new_name
        }
        user.reload

        expect(user.name).to eq(new_name)
      end

      it "redirects to the user" do
        new_name = "New Name"
        new_email = "email@email.email"
        user = create(:user)
        request.headers["Authorization"] = "Token token=#{user.api_key}"
        put :update, params: {
            id: user.id,
            name: new_name,
            email: new_email,
        }
        body = JSON.parse(response.body)

        expect(body["id"]).to eq(user.id)
        expect(body["email"]).to eq(new_email)
        expect(body["name"]).to eq(new_name)
      end
    end

    context "with invalid params" do
      it "non-unique email" do
        user = create(:user)
        another_user = create(:user)
        request.headers["Authorization"] = "Token token=#{user.api_key}"
        put :update, params: {
            id: user.id,
            email: another_user.email
        }
        body = JSON.parse(response.body)

        expect(body["email"][0]).to eq(
          I18n.t("activerecord.errors.models.user.attributes.email.taken")
        )
      end

      it "blank email" do
        user = create(:user)
        request.headers["Authorization"] = "Token token=#{user.api_key}"
        put :update, params: {
            id: user.id,
            email: nil
        }
        body = JSON.parse(response.body)

        expect(body["email"][0]).to eq(
          I18n.t("activerecord.errors.models.user.attributes.email.blank")
        )
      end

      it "invalid email format" do
        user = create(:user)
        request.headers["Authorization"] = "Token token=#{user.api_key}"
        put :update, params: {
            id: user.id,
            email: "email"
        }
        body = JSON.parse(response.body)

        expect(body["email"][0]).to eq(
          I18n.t("activerecord.errors.models.user.attributes.email.invalid")
        )
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested user" do
      user = create(:user)
      request.headers["Authorization"] = "Token token=#{user.api_key}"

      expect {
        delete :destroy, params: {id: user.id}
      }.to change(User, :count).by(-1)
    end

    it "returnes 200 status" do
      user = create(:user)
      request.headers["Authorization"] = "Token token=#{user.api_key}"
      delete :destroy, params: {id: user.id}

      expect(response.status).to eq(200)
    end

    it "returns success message" do
      user = create(:user)
      request.headers["Authorization"] = "Token token=#{user.api_key}"
      delete :destroy, params: {id: user.id}

      expect(response.body).to eq(I18n.t("confirms.user.success_destroyed"))
    end
  end
end
