class Assessor::CommentsController < Assessor::BaseController
  helper_method :form_answer

  def create
    @comment = form_answer.comments.build(create_params)
    authorize @comment, :create?

    @comment.authorable = current_assessor
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
          redirect_to assessor_form_answer_path(form_answer)
        end
      end
    end
  end

  def update
    authorize resource, :update?
    log_event if resource.update(update_params)

    respond_to do |format|
      format.html { redirect_to([namespace_name, form_answer]) }
      format.js { head :ok }
    end
  end

  def destroy
    authorize resource, :destroy?

    log_event if resource.destroy

    respond_to do |format|
      format.json { render(json: :ok) }
      format.html { redirect_to assessor_form_answer_path(form_answer) }
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
    params.require(:comment).permit(:flagged).merge(section: "critical")
  end

  def resource
    @comment ||= form_answer.comments.critical.find(params[:id])
  end

  def create_params
    params.require(:comment).permit(:body, :flagged).merge(section: "critical")
  end

  def form_answer
    @form_answer ||= @award_year.form_answers.find(params[:form_answer_id])
  end
end
