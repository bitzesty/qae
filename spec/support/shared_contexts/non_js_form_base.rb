require 'rails_helper'

shared_context "non js form base" do
  let!(:user) do
    FactoryBot.create :user, :completed_profile
  end

  let!(:account) do
    user.reload.account
  end

  let(:settings) do
    Settings.first
  end

  private

  def prepare_setting_deadlines
    %w(innovation trade mobility development).each do |award|
      start = settings.deadlines.public_send("#{award}_submission_start")
      start.update_column(:trigger_at, Time.zone.now - 20.days)
    end

    finish = settings.deadlines.where(kind: "submission_end").first
    finish.update_column(:trigger_at, Time.zone.now + 20.days)

    settings.reload
  end
end
