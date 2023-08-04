class Admin::CommentsController < Admin::BaseController
  helper_method :form_answer

  def new
    @comment = form_answer.comments.build
    authorize @comment, :create?

    respond_to do |format|
      format.html { render :new, layout: false }
    end
  end

  def create
    @comment = form_answer.comments.build(create_params)
    authorize @comment, :create?

    @comment.authorable = current_admin
    log_event if @comment.save

    respond_to do |format|
      format.html do
        if request.xhr? || request.format.js?
          if @comment.persisted?
            render partial: "admin/form_answers/comment",
                   locals: { comment: @comment, resource: form_answer }
          else
            head :ok
          end
        else
          render_flash_message_for(@comment)
          redirect_to admin_form_answer_path(form_answer)
        end
      end
    end
  end

  def update
    authorize resource, :update?
    log_event if resource.update(update_params)

    respond_to do |format|
      format.html do 
        render_flash_message_for(resource)
        redirect_to([namespace_name, form_answer]) 
      end
      format.js { head :ok }
    end
  end

  def destroy
    authorize resource, :destroy?

    log_event if resource.destroy

    respond_to do |format|
      format.json { render(json: :ok)}
      format.html do 
        render_flash_message_for(resource)
        redirect_to(admin_form_answer_path(form_answer))
      end
    end
  end

  private

  def action_type
    "#{comment_type}_#{action_name}"
  end

  def comment_type
    "#{resource.section}_comment"
  end

  def update_params
    params.require(:comment).permit(:flagged)
  end

  def resource
    @comment ||= form_answer.comments.find(params[:id])
  end

  def create_params
    params.require(:comment).permit :body, :section, :flagged
  end

  def form_answer
    @form_answer ||= FormAnswer.find(params[:form_answer_id])
  end
end
