module CommercialFiguresMixin

  def show
    send_data file_record.attachment.read,
              filename: file_record.attachment.file.filename,
              disposition: "attachment"
  end

  def destroy
    if deadline_allows_deletion?
      if file_record.destroy
        log_event
      end
    else
      flash[:notice] = "Can't delete files after the deadline"
    end

    redirect_to users_form_answer_figures_and_vat_returns_url(form_answer)
  end

  private

  def upload_response(record, saved)
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
          render json: record,
                 status: :created,
                 content_type: "text/plain"
        else
          render json: { errors: humanized_errors(record) }.to_json,
                 status: :unprocessable_entity
        end
      end
    end
  end

  def humanized_errors(record)
    record.errors
      .full_messages
      .reject { |m| m == "Attachment This field cannot be blank" }
      .join(", ")
      .gsub("Attachment ", "")
  end


  def figures_wrapper
    @figures_wrapper ||= (form_answer.shortlisted_documents_wrapper || form_answer.build_shortlisted_documents_wrapper)

    @figures_wrapper.save! if !@figures_wrapper.persisted?

    @figures_wrapper
  end


  def form_answer
    @form_answer ||= current_user.account
                       .form_answers
                       .find(params[:form_answer_id])
  end

  def scope
    raise NotImplementedError
  end

  def file_record
    @file_record ||= scope.find(params[:id])
  end

  def deadline_allows_deletion?
    !Settings.after_current_audit_certificates_deadline?
  end
end
