class Users::VatReturnsController < Users::BaseController

  def show
    vat_returns = form_answer.vat_returns_files.find(params[:id])

    send_data vat_returns.attachment.read,
              filename: "#{vat_returns.attachment.file.filename}_#{form_answer.urn}_#{form_answer.decorate.pdf_filename}",
              disposition: "attachment"
  end

  def create
    vat_returns = figures_wrapper.vat_returns_files.new(vat_returns_file_params)
    vat_returns.form_answer = form_answer

    if saved = vat_returns.save
      # log_event
    end


    respond_to do |format|
      format.json do
        if saved
          render json: vat_returns,
                 status: :created,
                 content_type: "text/plain"
        else
          render json: { errors: humanized_errors(vat_returns) }.to_json,
                 status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    if deadline_allows_deletion?
      form_answer.vat_returns_files.find(params[:id]).destroy
    end

    redirect_to users_form_answer_figures_and_vat_returns_url(form_answer)
  end

  private

  def deadline_allows_deletion?
    true
  end

  def form_answer
    @form_answer ||= current_user.account.
                       form_answers.
                       find(params[:form_answer_id])
  end

  def figures_wrapper
    @figures_wrapper ||= (form_answer.shortlisted_documents_wrapper || form_answer.build_shortlisted_documents_wrapper)

    @figures_wrapper.save! if !@figures_wrapper.persisted?

    @figures_wrapper
  end

  def humanized_errors(vat_returns)
    vat_returns.errors
      .full_messages
      .reject { |m| m == "Attachment This field cannot be blank" }
      .join(", ")
      .gsub("Attachment ", "")
  end

  def vat_returns_file_params
    # This is fix of "missing 'audit_certificate' param"
    # if no any was selected in file input
    if params[:vat_returns_file].blank?
      params.merge!(
        vat_returns_file: {
          attachment: ""
        }
      )
    end

    params.require(:vat_returns_file).permit(:attachment)
  end
end
