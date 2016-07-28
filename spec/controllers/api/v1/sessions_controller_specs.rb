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

        expect(response).to have_http_status(200)
        expect(response.body).to eq(I18n.t("confirms.user.logged_in"))
      end
    end

    context "Wrong credentials" do
      it "email" do
        user = create(:user)

        post :create, params: {
            "email": "wrong_email",
            "password": user.password
        }

        expect(response).to have_http_status(401)
        expect(response.body).to eq(I18n.t("errors.user.wrong_credentials"))
      end

      it "password" do
        user = create(:user)

        post :create, params: {
            "email": user.email,
            "password": "wrong_password"
        }

        expect(response).to have_http_status(401)
        expect(response.body).to eq(I18n.t("errors.user.wrong_credentials"))
      end
    end

    context "Another user logged in" do
      it "returns status 403 and message" do
        user1 = create(:user)
        user2 = create(:user)
        session[:user_id] = user1.id
        post :create, params: {
            "email": user2.email,
            "password": user2.password
        }

        expect(response).to have_http_status(403)
        expect(response.body).to eq(I18n.t("errors.user.login"))
      end
    end
  end

  describe "GET #destroy (/v1/logout)" do
    context "User is logged in" do
      it "returns status 200 and message" do
        user = create(:user)
        session[:user_id] = user.id

        get :destroy

        expect(response).to have_http_status(200)
        expect(response.body).to eq(I18n.t("confirms.user.logged_out"))
      end
    end

    context "User is not logged in" do
      it "returns status 403 and message" do

        get :destroy

        expect(response).to have_http_status(403)
        expect(response.body).to eq(I18n.t("errors.user.logout"))
      end
    end
  end
end
