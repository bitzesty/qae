# frozen_string_literal: true

module AutosaveTokenGeneration
  extend ActiveSupport::Concern

  included do
    before_create :set_autosave_token
  end

  private

  def set_autosave_token
    self.autosave_token = generate_token
  end

  def generate_token
    loop do
      token = SecureRandom.hex(10)
      break token unless self.class.where(autosave_token: token).exists?
    end
  end
end
