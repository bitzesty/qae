class Users::ActualFiguresController < Users::BaseController
  include CommercialFiguresMixin
  include FiguresAuthorisationCheck

  def new
    @form_answer = form_answer
    @actual_figures = figures_wrapper.build_commercial_figures_file
  end

  def create
    @actual_figures = figures_wrapper.build_commercial_figures_file(commercial_figures_file_params)
    @actual_figures.form_answer = form_answer

    if saved = @actual_figures.save
      log_event
    end

    upload_response(@actual_figures, saved)
  end

  private

  def scope
    form_answer.commercial_figures_files
  end

  def action_type
    case action_name
    when "create"
      "actual_figures_file_uploaded"
    when "destroy"
      "actual_figures_file_destroyed"
    else
      raise "Attempted to log an unsupported action (#{action_name})"
    end
  end

  def commercial_figures_file_params
    # This is fix of "missing 'audit_certificate' param"
    # if no any was selected in file input
    if params[:commercial_figures_file].blank?
      params.merge!(
        commercial_figures_file: {
          attachment: "",
        }
      )
    end

    params.require(:commercial_figures_file).permit(:attachment)
  end
end
