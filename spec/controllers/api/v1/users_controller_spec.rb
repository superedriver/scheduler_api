require "rails_helper"

RSpec.describe Api::V1::UsersController, type: :controller do

  describe 'user is not authorized' do
    it_behaves_like 'user is not authorized', :get, :show
    it_behaves_like 'user is not authorized', :patch, :update
    it_behaves_like 'user is not authorized', :delete, :destroy
  end

  describe "GET #show" do
    it "return user if user exist" do
      user = create(:user)
      get :show, params: {
          token: user.token
      }

      body = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(body["email"]).to eq(user.email)
      expect(body["name"]).to eq(user.name)
    end
  end

  describe "POST #create /registration" do
    context "with valid params" do
      it "creates a new User" do
        user = build(:user)

        expect {
          post :create, params: {
            user: {
              name: user.name,
              email: user.email,
              password: user.password,
              password_confirmation: user.password
            }
          }
        }.to change(User, :count).by(1)
      end

      it "returns created user after creation" do
        user = build(:user)
        post :create, params: {
          user: {
            name: user.name,
            email: user.email,
            password: user.password,
            password_confirmation: user.password
          }
        }
        body = JSON.parse(response.body)

        expect(body["email"]).to eq(user.email)
        expect(body["name"]).to eq(user.name)
      end
    end

    context "with invalid params" do
      context "#email" do
        it "non-unique" do
          user1 = create(:user)

          post :create, params: {
            user: {
              name: user1.name,
              email: user1.email,
              password: user1.password,
              password_confirmation: user1.password
            }
          }
          body = JSON.parse(response.body)

          expect(body["email"][0]).to eq(
            I18n.t("activerecord.errors.models.user.attributes.email.taken")
          )
        end

        it "blank" do
          user1 = build(:user)
          post :create, params: {
            user: {
              name: user1.name,
              password: user1.password,
              password_confirmation: user1.password
            }
          }
          body = JSON.parse(response.body)

          expect(body["email"][0]).to eq(
            I18n.t("activerecord.errors.models.user.attributes.email.blank")
          )
        end

        it "invalid format" do
          post :create, params: {
            user: {
              name: "John Doe",
              email: "email",
              password: "password",
              password_confirmation: "password"
            }
          }
          body = JSON.parse(response.body)

          expect(body["email"][0]).to eq(
            I18n.t("activerecord.errors.models.user.attributes.email.invalid")
          )
        end
      end

      context "#password" do
        it "blank password" do
          user1 = build(:user)
          post :create, params: {
            user: {
              name: user1.name,
              email: user1.email,
              password_confirmation: user1.password
            }
          }
          body = JSON.parse(response.body)

          expect(body["password"][0]).to eq(
            I18n.t("activerecord.errors.models.user.attributes.password.blank")
          )
        end

        it "blank password_confirmation" do
          user1 = build(:user)
          post :create, params: {
            user: {
              name: user1.name,
              email: user1.email,
              password: user1.password
            }
          }
          body = JSON.parse(response.body)

          expect(body["password_confirmation"][0]).to eq(
            I18n.t("activerecord.errors.models.user.attributes.password_confirmation.blank"))
        end

        it "password != password_confirmation" do
          user1 = build(:user)
          post :create, params: {
            user: {
              name: user1.name,
              email: user1.email,
              password: "qwerty",
              password_confirmation: "qwerty_qwerty"
            }
          }
          body = JSON.parse(response.body)

          expect(body["password_confirmation"][0]).to eq(
            I18n.t("activerecord.errors.models.user.attributes.password_confirmation.confirmation"))
        end
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      it "updates the requested user" do
        new_name = "New Name"
        user = create(:user)

        put :update, params: {
          user: {
            name: new_name,
            password: "qwert",
            password_confirmation: "qwert",
          },
          token: user.token
        }
        user.reload
        expect(user.name).to eq(new_name)
      end

      it "redirects to the user" do
        new_name = "New Name"
        new_email = "email@email.email"
        user = create(:user)

        put :update, params: {
          user: {
            name: new_name,
            email: new_email,
            password: "qwert",
            password_confirmation: "qwert"
          },
          token: user.token
        }
        body = JSON.parse(response.body)

        expect(body["id"]).to eq(user.id)
        expect(body["email"]).to eq(new_email)
        expect(body["name"]).to eq(new_name)
      end
    end

    context "with invalid params" do
      context "#email" do
        it "non-unique" do
          user1 = create(:user)
          user2 = create(:user)

          put :update, params: {
            user: {
              email: user1.email
            },
            token: user2.token
          }
          body = JSON.parse(response.body)

          expect(body["email"][0]).to eq(
            I18n.t("activerecord.errors.models.user.attributes.email.taken")
          )
        end

        it "blank" do
          user = create(:user)

          put :update, params: {
            user: {
              email: nil
            },
            token: user.token
          }
          body = JSON.parse(response.body)

          expect(body["email"][0]).to eq(
            I18n.t("activerecord.errors.models.user.attributes.email.blank")
          )
        end

        it "invalid format" do
          user = create(:user)

          put :update, params: {
            user: {
              email: "invalid_format"
            },
            token: user.token
          }
          body = JSON.parse(response.body)

          expect(body["email"][0]).to eq(
            I18n.t("activerecord.errors.models.user.attributes.email.invalid")
          )
        end
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested user" do
      user = create(:user)

      expect {
        delete :destroy, params: {
            token: user.token
        }
      }.to change(User, :count).by(-1)
    end

    it "returnes 200 status with message" do
      user = create(:user)

      delete :destroy, params: {
          token: user.token
      }

      expect(response.status).to eq(200)
      expect(response.body).to eq(I18n.t("confirms.user.success_destroyed"))
    end
  end
end
