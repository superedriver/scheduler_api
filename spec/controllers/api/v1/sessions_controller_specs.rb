require "rails_helper"

RSpec.describe Api::V1::SessionsController, type: :controller do
  describe "POST #create (/v1/login)" do
    context "Correct credentials" do
      it "returns status 200 and message" do
        user = create(:user)

        post :create, params: {
            "email": user.email,
            "password": user.password
        }

        body = JSON.parse(response.body)

        expect(response).to have_http_status(200)
        expect(body["message"]).to eq(I18n.t("confirms.user.logged_in"))
        expect(body["token"]).to eq(user.token)
      end
    end

    context "Wrong credentials" do
      it "email" do
        user = create(:user)

        post :create, params: {
            "email": "wrong_email",
            "password": user.password
        }

        body = JSON.parse(response.body)

        expect(response).to have_http_status(401)
        expect(body["message"]).to eq(I18n.t("errors.user.wrong_credentials"))
      end

      it "password" do
        user = create(:user)

        post :create, params: {
            "email": user.email,
            "password": "wrong_password"
        }

        body = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(body["message"]).to eq(I18n.t("errors.user.wrong_credentials"))
      end
    end
  end
end
