require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  subject { user }

  it { expect respond_to(:email) }
  it { expect respond_to(:name) }
  it { expect respond_to(:created_at) }
  it { expect respond_to(:updated_at) }
  it { expect respond_to(:events) }
  it { expect respond_to(:password_digest) }

  describe "validations" do
    context "#email" do
      it "blank" do
        user = build(
          :user,
          email: ""
        )
        user.valid?
        expect(user.errors.messages[:email].length).to eq(2)
        expect(user.errors.messages[:email][0]).
            to eq(I18n.t("activerecord.errors.models.user.attributes.email.blank"))
        expect(user.errors.messages[:email][1]).
            to eq(I18n.t("activerecord.errors.models.user.attributes.email.invalid"))
      end

      it "without @" do
        user = build(
          :user,
          email: "cvsdfv"
        )
        user.valid?
        expect(user.errors.messages[:email].length).to eq(1)
        expect(user.errors.messages[:email][0]).
            to eq(I18n.t("activerecord.errors.models.user.attributes.email.invalid"))
      end

      it "with @ but without '.' " do
        user = build(
          :user,
          email: "cvsdfv@sdfv"
        )
        user.valid?
        expect(user.errors.messages[:email].length).to eq(1)
        expect(user.errors.messages[:email][0]).
            to eq(I18n.t("activerecord.errors.models.user.attributes.email.invalid"))
      end

      it "not unique" do
        create(
          :user,
          email: "qwerty@gmail.com"
        )
        user = build(
          :user,
          email: "qwerty@gmail.com"
        )
        user.valid?
        expect(user.errors.messages[:email].length).to eq(1)
        expect(user.errors.messages[:email][0]).
            to eq(I18n.t("activerecord.errors.models.user.attributes.email.taken"))
      end

      it "upcase" do
        create(
          :user,
          email: "UpCaSE@gmail.com"
        )
        user = build(
          :user,
          email: "upcase@gmail.com"
        )
        user.valid?
        expect(user.errors.messages[:email].length).to eq(1)
        expect(user.errors.messages[:email][0]).
            to eq(I18n.t("activerecord.errors.models.user.attributes.email.taken"))
      end
    end

    context "#password" do
      it "too short" do
        user = build(
            :user,
            password: "1",
            password_confirmation: "1"
        )
        user.valid?
        expect(user.errors.messages[:pasws].length).to eq(2)
        expect(user.errors.messages[:email][0]).
            to eq(I18n.t("activerecord.errors.models.user.attributes.email.blank"))
        expect(user.errors.messages[:email][1]).
            to eq(I18n.t("activerecord.errors.models.user.attributes.email.invalid"))
      end

      it "without @" do
        user = build(
            :user,
            email: "cvsdfv"
        )
        user.valid?
        expect(user.errors.messages[:email].length).to eq(1)
        expect(user.errors.messages[:email][0]).
            to eq(I18n.t("activerecord.errors.models.user.attributes.email.invalid"))
      end

      it "with @ but without '.' " do
        user = build(
            :user,
            email: "cvsdfv@sdfv"
        )
        user.valid?
        expect(user.errors.messages[:email].length).to eq(1)
        expect(user.errors.messages[:email][0]).
            to eq(I18n.t("activerecord.errors.models.user.attributes.email.invalid"))
      end

      it "not unique" do
        create(
            :user,
            email: "qwerty@gmail.com"
        )
        user = build(
            :user,
            email: "qwerty@gmail.com"
        )
        user.valid?
        expect(user.errors.messages[:email].length).to eq(1)
        expect(user.errors.messages[:email][0]).
            to eq(I18n.t("activerecord.errors.models.user.attributes.email.taken"))
      end

      it "upcase" do
        create(
            :user,
            email: "UpCaSE@gmail.com"
        )
        user = build(
            :user,
            email: "upcase@gmail.com"
        )
        user.valid?
        expect(user.errors.messages[:email].length).to eq(1)
        expect(user.errors.messages[:email][0]).
            to eq(I18n.t("activerecord.errors.models.user.attributes.email.taken"))
      end
    end
  end
end
