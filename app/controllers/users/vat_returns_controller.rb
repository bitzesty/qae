class Users::VatReturnsController < Users::BaseController
  include CommercialFiguresMixin
  include FiguresAuthorisationCheck

  def new
    @form_answer = form_answer
    @vat_returns = figures_wrapper.vat_returns_files.new
  end

  def create
    @vat_returns = figures_wrapper.vat_returns_files.new(vat_returns_file_params)
    @vat_returns.form_answer = form_answer

    if saved = @vat_returns.save
      log_event
    end

    upload_response(@vat_returns, saved)
  end

  private

  def scope
    form_answer.vat_returns_files
  end

  def action_type
    case action_name
    when "create"
      "vat_returns_file_uploaded"
    when "destroy"
      "vat_returns_file_destroyed"
    else
      raise "Attempted to log an unsupported action (#{action_name})"
    end
  end

  def vat_returns_file_params
    # This is fix of "missing 'audit_certificate' param"
    # if no any was selected in file input
    if params[:vat_returns_file].blank?
      params.merge!(
        vat_returns_file: {
          attachment: "",
        },
      )
    end

    params.require(:vat_returns_file).permit(:attachment)
  end
end
