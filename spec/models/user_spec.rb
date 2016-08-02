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
  it { expect respond_to(:token) }

  describe "#create token" do
    it "not saved user hasn't got token" do
      user = build(:user)

      expect(user.token).to be_nil
    end

    it "saved user has token" do
      user = build(:user)
      user.save
      expect(user.token).not_to be_nil
    end
  end

  describe "validations" do
    describe "create user" do
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
          expect(user.errors.messages[:password].length).to eq(1)
          expect(user.errors.messages[:password][0]).
            to eq(I18n.t("activerecord.errors.models.user.attributes.password.too_short"))
        end

        it "blank" do
          user = build(
            :user,
            password: nil,
            password_confirmation: nil
          )
          user.valid?
          expect(user.errors.messages[:password].length).to eq(2)
          expect(user.errors.messages[:password][0]).
            to eq(I18n.t("activerecord.errors.models.user.attributes.password.blank"))
          expect(user.errors.messages[:password][1]).
            to eq(I18n.t("activerecord.errors.models.user.attributes.password.too_short"))
        end

        it "different password and password_confirmation" do
          user = build(
            :user,
            password: "qaz",
            password_confirmation: "zaq"
          )
          user.valid?
          expect(user.errors.messages[:password_confirmation].length).to eq(1)
          expect(user.errors.messages[:password_confirmation][0]).
            to eq(I18n.t("activerecord.errors.models.user.attributes.password_confirmation.confirmation"))
        end
      end
    end

    describe "update user" do
      context "#email" do
        it "blank" do
          user = create(:user)
          user.email = ""
          user.valid?
          expect(user.errors.messages[:email].length).to eq(2)
          expect(user.errors.messages[:email][0]).
            to eq(I18n.t("activerecord.errors.models.user.attributes.email.blank"))
          expect(user.errors.messages[:email][1]).
            to eq(I18n.t("activerecord.errors.models.user.attributes.email.invalid"))
        end

        it "without @" do
          user = create(:user)
          user.email = "sdafg"
          user.valid?
          expect(user.errors.messages[:email].length).to eq(1)
          expect(user.errors.messages[:email][0]).
            to eq(I18n.t("activerecord.errors.models.user.attributes.email.invalid"))
        end

        it "with @ but without '.' " do
          user = create(:user)
          user.email = "sdafg@sfd"
          user.valid?
          expect(user.errors.messages[:email].length).to eq(1)
          expect(user.errors.messages[:email][0]).
            to eq(I18n.t("activerecord.errors.models.user.attributes.email.invalid"))
        end

        it "not unique" do
          email = "qwerty@gmail.com"
          create(
            :user,
            email: email
          )
          user = create(:user)
          user.email = email
          user.valid?

          expect(user.errors.messages[:email].length).to eq(1)
          expect(user.errors.messages[:email][0]).
            to eq(I18n.t("activerecord.errors.models.user.attributes.email.taken"))
        end

        it "upcase" do
          email = "UpCaSE@gmail.com"
          create(
            :user,
            email: email
          )
          user = create(:user)
          user.email = email.downcase
          user.valid?
          expect(user.errors.messages[:email].length).to eq(1)
          expect(user.errors.messages[:email][0]).
            to eq(I18n.t("activerecord.errors.models.user.attributes.email.taken"))
        end
      end

      context "#password" do
        it "too short" do
          user = create(:user)
          user.password = "1"
          user.password_confirmation = "1"

          user.valid?
          expect(user.errors.messages[:password].length).to eq(1)
          expect(user.errors.messages[:password][0]).
            to eq(I18n.t("activerecord.errors.models.user.attributes.password.too_short"))
        end

        it "blank" do
          user = create(:user)
          user.password = nil
          user.password_confirmation = nil
          user.valid?
          expect(user.errors.messages[:password].length).to eq(1)
          expect(user.errors.messages[:password][0]).
            to eq(I18n.t("activerecord.errors.models.user.attributes.password.blank"))
        end

        it "different password and password_confirmation" do
          user = create(:user)
          user.password = "qaz"
          user.password_confirmation = "zaq"
          user.valid?
          expect(user.errors.messages[:password_confirmation].length).to eq(1)
          expect(user.errors.messages[:password_confirmation][0]).
            to eq(I18n.t("activerecord.errors.models.user.attributes.password_confirmation.confirmation"))
        end
      end
    end
  end
end
