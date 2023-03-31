# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Confirmations", type: :request) do
  let(:user) { create(:user) }

  describe "GET /confirmations/new" do
    it "returns successful response" do
      get new_confirmation_path
      expect(response).to(have_http_status(:success))
    end

    it "redirects to root if logged in" do
      login_as user
      get new_confirmation_path
      expect(response).to(redirect_to(root_path))
      expect(flash[:alert]).to(eq("You are already logged in."))
    end
  end

  describe "POST /confirmations" do
    it "sends confirmation email if user is not confirmed" do
      User.create(email: "user2@example.com", password: "password", password_confirmation: "password", name: "User2")
      post confirmations_path, params: { user: { email: "user2@example.com" } }
      expect(response).to(redirect_to(root_path))
      expect(flash[:notice]).to(eq("Check your email for confirmation instructions."))
    end

    it "does not send confirmation email if user does not exist" do
      post confirmations_path, params: { user: { email: "invalid@example.com" } }
      expect(response).to(redirect_to(new_confirmation_path))
      expect(flash[:alert]).to(eq("We could not find a user with that email or that email has already been confirmed."))
    end

    it "does not send confirmation email if user is already confirmed" do
      post confirmations_path, params: { user: { email: user.email } }
      expect(response).to(redirect_to(new_confirmation_path))
      expect(flash[:alert]).to(eq("We could not find a user with that email or that email has already been confirmed."))
    end
  end

  describe "GET /confirmations/:confirmation_token" do
    it "confirms user if token is valid" do
      u = User.create(
        email: "user2@example.com",
        password: "password",
        password_confirmation: "password",
        name: "User2",
      )
      mail = u.send_confirmation_email!
      get edit_confirmation_path(mail.body.parts[0].body.raw_source.split("/")[-2])
      expect(response).to(redirect_to(root_path))
      expect(flash[:notice]).to(eq("Your account has been confirmed."))
    end

    it "does not confirm user if token is invalid" do
      get edit_confirmation_path("invalid_token")
      expect(response).to(redirect_to(new_confirmation_path))
      expect(flash[:alert]).to(eq("Invalid token."))
    end
  end
end
