class Admin::DeadlinesController < Admin::BaseController
  before_action :load_deadline, only: [:update]

  def update
    authorize @deadline, :update?

    service = UpdateDeadlineService.new(@deadline, update_params)
    service.perform

    respond_to do |format|
      format.html do
        if @deadline.valid?
          flash.notice = "Deadline successfully updated"
        else
          flash.alert = "Deadline was not updated"
        end

        redirect_to admin_settings_path
      end

      format.js
    end
  end

  private

  def load_deadline
    @deadline = @settings.deadlines.find(params[:id])
  end

  def update_params
    params.require(:deadline).permit(%i[formatted_trigger_at_date formatted_trigger_at_time])
  end
end
