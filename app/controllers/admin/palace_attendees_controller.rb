class Admin::PalaceAttendeesController < Admin::BaseController
  after_action :log_event, only: [:create, :update, :destroy]
  include PalaceAttendeesMixin
end
