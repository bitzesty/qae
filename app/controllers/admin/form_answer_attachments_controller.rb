class Admin::FormAnswerAttachmentsController < Admin::BaseController
  def create
    @form_answer_attachment = form_answer.form_answer_attachments.build(create_params)
    authorize @form_answer_attachment, :create?

    @form_answer_attachment.attachable = current_admin

    if @form_answer_attachment.save
      respond_to do |format|
        format.html do
          unless request.xhr?
            redirect_to admin_form_answer_path(form_answer)
          else
            render_for_js
          end
        end
      end
    end
  end

  def show
    authorize resource, :show?
    send_data resource.file.read, filename: resource.filename, disposition: 'inline'
  end

  def destroy
    authorize resource, :destroy?
    resource.destroy

    respond_to do |format|
      format.html do
        unless request.xhr?
          redirect_to admin_form_answer_path(form_answer)
        else
          render nothing: true
        end
      end
    end
  end

  private

  def resource
    @form_answer_attachment ||= form_answer.form_answer_attachments.find(params[:id])
  end

  def render_for_js
    render partial: 'form_answer_attachment', locals: {
                                                        form_answer_attachment: @form_answer_attachment,
                                                        form_answer: form_answer
                                                      }
  end

  def create_params
    params[:form_answer_attachment].permit(:file)
  end

  def form_answer
    @form_answer ||= FormAnswer.find(params[:form_answer_id])
  end
end
