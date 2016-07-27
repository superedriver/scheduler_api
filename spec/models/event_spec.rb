require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:event) { create(:event) }
  subject { event }

  it { expect respond_to(:name) }
  it { expect respond_to(:description) }
  it { expect respond_to(:date_start) }
  it { expect respond_to(:date_finish) }
  it { expect respond_to(:associate) }
  it { expect respond_to(:created_at) }
  it { expect respond_to(:updated_at) }
  it { expect respond_to(:user_id) }
  it { expect respond_to(:user) }

  describe "validations" do
    context "#date_start" do
      it "blank" do
        event = build(
          :event,
          name: "Meeting",
          description: "Meeting with Projector",
          date_start: nil,
          date_finish: "2016-07-22 14:05:29",
          associate: 1
        )
        event.valid?
        expect(event.errors.messages[:date_start].length).to eq(1)
        expect(event.errors.messages[:date_start][0]).
            to eq(I18n.t("activerecord.errors.models.event.attributes.date_start.blank"))
      end
    end

    context "#date_finish" do
      it "blank" do
        event = build(
          :event,
          name: "Meeting",
          description: "Meeting with Projector",
          date_start: "2016-07-22 14:05:29",
          date_finish: nil,
          associate: 1
        )
        event.valid?
        expect(event.errors.messages[:date_finish].length).to eq(1)
        expect(event.errors.messages[:date_finish][0]).
            to eq(I18n.t("activerecord.errors.models.event.attributes.date_finish.blank"))
      end
    end

    context "#user_id" do
      it "blank" do
        event = build(
          :event,
          name: "Meeting",
          description: "Meeting with Projector",
          date_start: "2016-07-22 14:05:29",
          date_finish: "2016-07-22 15:05:29",
          associate: 1,
          user_id: nil
        )
        event.valid?
        expect(event.errors.messages[:user_id].length).to eq(1)
        expect(event.errors.messages[:user_id][0]).
            to eq(I18n.t("activerecord.errors.models.event.attributes.user_id.blank"))
      end
    end
  end
end
