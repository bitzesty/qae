class Users::ActualFiguresController < Users::BaseController
  def new
    @form_answer = form_answer
    @actual_figures = figures_wrapper.build_commercial_figures_file
  end

  def show
    actual_figures = form_answer.commercial_figures_files.find(params[:id])

    send_data actual_figures.attachment.read,
              filename: "#{actual_figures.attachment.file.filename}_#{form_answer.urn}_#{form_answer.decorate.pdf_filename}",
              disposition: "attachment"
  end

  def create
    @actual_figures = figures_wrapper.build_commercial_figures_file(commercial_figures_file_params)
    @actual_figures.form_answer = form_answer

    if saved = @actual_figures.save
      log_event
    end

    respond_to do |format|
      format.html do
        if saved
          redirect_to users_form_answer_figures_and_vat_returns_url(form_answer)
        else
          @form_answer = form_answer
          render :new
        end
      end

      format.json do
        if saved
          render json: @actual_figures,
                 status: :created,
                 content_type: "text/plain"
        else
          render json: { errors: humanized_errors(actual_figures) }.to_json,
                 status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    if deadline_allows_deletion?
      if form_answer.commercial_figures_files.find(params[:id]).destroy
        log_event
      end
    end

    redirect_to users_form_answer_figures_and_vat_returns_url(form_answer)
  end

  private

  def deadline_allows_deletion?
    true
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

  def humanized_errors(actual_figures)
    actual_figures.errors
      .full_messages
      .reject { |m| m == "Attachment This field cannot be blank" }
      .join(", ")
      .gsub("Attachment ", "")
  end

  def commercial_figures_file_params
    # This is fix of "missing 'audit_certificate' param"
    # if no any was selected in file input
    if params[:commercial_figures_file].blank?
      params.merge!(
        commercial_figures_file: {
          attachment: ""
        }
      )
    end

    params.require(:commercial_figures_file).permit(:attachment)
  end
end
