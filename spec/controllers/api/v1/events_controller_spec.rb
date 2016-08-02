require 'rails_helper'

RSpec.describe Api::V1::EventsController, type: :controller do

  before(:each) { request.headers['Content-Type'] = "application/json" }

  def self.returns_401_when_not_authorized(*actions)
    actions.each do |action|
      it "#{action} returns 401 when not authorized" do
        event = create(:event)
        verb = if action == :update
                 "PATCH"
               elsif action == :destroy
                 "DELETE"
               elsif action == :create
                 "POST"
               else
                 "GET"
               end

        process action, verb, id: event.id
        expect(response).to have_http_status(401)
        expect(response.body).to eq(I18n.t("errors.user.non_authorized"))
      end
    end
  end
  returns_401_when_not_authorized :index, :show, :update, :destroy, :create

  describe "GET #index" do
    it "return events if they exist" do
      user = create(:user)
      event1 = create(:event,
        name: "Event1",
        user_id: user.id
      )
      event2 = create(:event,
        name: "Event2",
        user_id: user.id
      )

      get :index, params: { token: user.token }

      body = JSON.parse(response.body)

      expect(body.length).to eql(2)
      expect(body[0]["name"]).to eq(event1.name)
      expect(body[1]["name"]).to eq(event2.name)
    end
  end

  describe "GET #show" do
    it "return event if event exist" do
      user = create(:user)
      event = create(:event,
        name: "Event1",
        user_id: user.id
      )

      get :show, params: {
        id: event.id,
        token: user.token
      }

      body = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(body["name"]).to eq(event.name)
    end

    it "return 404 if event not exist" do
      user = create(:user)

      get :show, params: {
        id: 0,
        token: user.token
      }

      expect(response).to have_http_status(404)
      expect(response.body).to eq(I18n.t("errors.event.not_found"))
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Event" do
        user = create(:user)
        event = build(:event)

        expect {
          post :create, params: {
            date_start: event.date_start,
            date_finish: event.date_finish,
            token: user.token
          }
        }.to change(Event, :count).by(1)
      end

      it "returns created event after creation" do
        name = "Event1"
        description = "Description1"

        user = create(:user)
        event = build(:event,
          name: name,
          description: description
        )

        post :create, params: {
          name: event.name,
          description: event.description,
          date_start: event.date_start,
          date_finish: event.date_finish,
          token: user.token
        }

        body = JSON.parse(response.body)

        expect(body["name"]).to eq(name)
        expect(body["description"]).to eq(description)
      end
    end

    context "with invalid params" do
      it "blank date_start" do
        user = create(:user)
        event = build(:event)

        post :create, params: {
          date_start: nil,
          date_finish: event.date_finish,
          token: user.token
        }

        body = JSON.parse(response.body)

        expect(body["date_start"][0]).to eq(
          I18n.t("activerecord.errors.models.event.attributes.date_start.blank")
        )
      end

      it "blank date_finish" do
        user = create(:user)
        event = build(:event)

        post :create, params: {
          date_start: event.date_start,
          date_finish: nil,
          token: user.token
        }

        body = JSON.parse(response.body)

        expect(body["date_finish"][0]).to eq(
          I18n.t("activerecord.errors.models.event.attributes.date_finish.blank")
        )
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      it "updates the requested event" do
        new_name = "New Name"
        user = create(:user)
        event = create(:event, user_id: user.id)

        put :update, params: {
          id: event.id,
          name: new_name,
          token: user.token
        }
        event.reload

        expect(event.name).to eq(new_name)
      end
    end

    it "redirects to the event" do
      new_name = "New Name"
      new_description = "new Description"
      user = create(:user)
      event = create(:event, user_id: user.id)

      put :update, params: {
          id: event.id,
          name: new_name,
          description: new_description,
          token: user.token
      }
      body = JSON.parse(response.body)

      expect(body["id"]).to eq(event.id)
      expect(body["name"]).to eq(new_name)
      expect(body["description"]).to eq(new_description)
    end

    context "with invalid params" do
      it "blank date_start" do
        user = create(:user)
        event = create(:event, user_id: user.id)

        put :update, params: {
          id: event.id,
          date_start: nil,
          token: user.token
        }

        body = JSON.parse(response.body)

        expect(body["date_start"][0]).to eq(
          I18n.t("activerecord.errors.models.event.attributes.date_start.blank")
        )
      end

      it "blank date_finish" do
        user = create(:user)
        event = create(:event, user_id: user.id)

        put :update, params: {
          id: event.id,
          date_finish: nil,
          token: user.token
        }

        body = JSON.parse(response.body)

        expect(body["date_finish"][0]).to eq(
          I18n.t("activerecord.errors.models.event.attributes.date_finish.blank")
        )
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested user" do
      user = create(:user)
      event = create(:event, user_id: user.id)

      expect {
        delete :destroy, params: {
          id: event.id,
          token: user.token
        }
      }.to change(Event, :count).by(-1)
    end

    it "returnes 200 status with message" do
      user = create(:user)
      event = create(:event, user_id: user.id)

      delete :destroy, params: {
        id: event.id,
        token: user.token
      }

      expect(response.status).to eq(200)
      expect(response.body).to eq(I18n.t("confirms.event.success_destroyed"))
    end
  end
end
