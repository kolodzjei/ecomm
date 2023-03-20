# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_secure_token :remember_token
  attr_accessor :current_password

  before_save :downcase_email
  before_save :downcase_unconfirmed_email
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :unconfirmed_email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :name, presence: true, length: { maximum: 50 }

  def confirm!
    if unconfirmed_or_reconfirming?
      return false if unconfirmed_email.present? && !update(email: unconfirmed_email, unconfirmed_email: nil)

      update_columns(confirmed_at: Time.current)
    else
      false
    end
  end

  def confirmed?
    confirmed_at.present?
  end

  def unconfirmed?
    !confirmed?
  end

  def generate_confirmation_token
    signed_id expires_in: 15.minutes, purpose: :confirmation
  end

  def send_confirmation_email!
    confirmation_token = generate_confirmation_token
    UserMailer.confirmation(self, confirmation_token).deliver_now
  end

  def generate_password_reset_token
    signed_id expires_in: 15.minutes, purpose: :reset_password
  end

  def send_password_reset_email!
    password_reset_token = generate_password_reset_token
    UserMailer.password_reset(self, password_reset_token).deliver_now
  end

  def reconfirming?
    unconfirmed_email.present?
  end

  def unconfirmed_or_reconfirming?
    unconfirmed? || reconfirming?
  end

  def confirmable_email
    if unconfirmed_email.present?
      unconfirmed_email
    else
      email
    end
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def downcase_unconfirmed_email
    return if unconfirmed_email.nil?

    self.unconfirmed_email = unconfirmed_email.downcase
  end
end
