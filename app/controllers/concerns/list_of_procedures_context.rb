module ListOfProceduresContext
  def show
    authorize form_answer, :download_list_of_procedures_pdf?
    redirect_to resource.attachment_url
  end

  def create
    authorize form_answer, :create_list_of_procedures_pdf?

    list_of_procedure = form_answer.build_list_of_procedure(list_of_procedure_params)

    if saved = list_of_procedure.save
      if form_answer.assessors.primary.present?
        Assessors::GeneralMailer.list_of_procedure_uploaded(form_answer.id).deliver_later!
      end

      Users::AuditCertificateMailer.notify(form_answer.id, form_answer.user_id).deliver_later!
    end

    respond_to do |format|
      if saved
        format.html do
          redirect_to [namespace_name, form_answer]
        end

        format.js do
          render  partial: "admin/form_answers/docs/post_shortlisting_docs",
            locals: {
            resource: form_answer.decorate
          },
          content_type: "text/plain"
        end
      else
        format.html do
          redirect_to [namespace_name, form_answer],
            alert: list_of_procedure.errors.full_messages.join(", ")
        end
        format.js do
          render json: list_of_procedure,
            status: :created,
            content_type: "text/plain"
        end
      end
    end
  end

  private

  def resource
    @list_of_procedure ||= form_answer.list_of_procedure
  end

  def form_answer
    @form_answer ||= FormAnswer.find(params[:form_answer_id])
  end

  def list_of_procedure_params
    if params[:list_of_procedure].blank?
      params.merge!(
        list_of_procedure: {
          attachment: ""
        }
      )
    end

    params.require(:list_of_procedure).permit(:attachment)
  end
end
