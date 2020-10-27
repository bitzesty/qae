class Users::ListOfProceduresController < Users::BaseController

  expose(:form_answer) do
    current_user.account.
                form_answers.
                find(params[:form_answer_id])
  end

  expose(:list_of_procedures) do
    form_answer.list_of_procedures
  end

  def create
    self.list_of_procedures = form_answer.build_list_of_procedures(list_of_procedures_params)

    saved = list_of_procedures.save
    log_event if saved

    respond_to do |format|
      format.html do
        if saved
          redirect_to users_form_answer_audit_certificate_url(form_answer),
                      notice: "List of procedures successfully uploaded!"
        else
          render :show
        end
      end

      format.json do
        if saved
          render json: list_of_procedures,
                 status: :created,
                 content_type: "text/plain"
        else
          render json: { errors: humanized_errors }.to_json,
                 status: :unprocessable_entity
        end
      end
    end
  end

  private

  def list_of_procedures_params
    # Handle situation where user hasn't attached anything through the file picker
    if params[:list_of_procedures].blank?
      params.merge!(
        list_of_procedures: {
          attachment: ""
        }
      )
    end

    params.require(:list_of_procedures).permit(:attachment)
  end

  def action_type
    "list_of_procedures_uploaded"
  end

  def humanized_errors
    list_of_procedures.errors
                     .full_messages
                     .reject { |m| m == "Attachment This field cannot be blank" }
                     .join(", ")
                     .gsub("Attachment ", "")
  end

end
