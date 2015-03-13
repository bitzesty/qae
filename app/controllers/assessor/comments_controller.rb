class Assessor::CommentsController < Assessor::BaseController
  helper_method :form_answer

  def new
    @comment = form_answer.comments.build(section: "critical")
    authorize @comment, :create?

    respond_to do |format|
      format.html { render :new, layout: false }
    end
  end

  def create
    @comment = form_answer.comments.build(create_params)
    authorize @comment, :create?

    @comment.authorable = current_assessor
    @comment.save

    respond_to do |format|
      format.html do
        if request.xhr?
          render partial: "admin/form_answers/comment",
                 locals: { comment: @comment, resource: form_answer }
        else
          redirect_to assessor_form_answer_path(form_answer)
        end
      end
    end
  end

  def update
    authorize resource, :update?
    resource.update(update_params)

    respond_to do |format|
      format.html { redirect_to([namespace_name, form_answer]) }
      format.js { render nothing: true }
    end
  end

  def destroy
    authorize resource, :destroy?

    resource.destroy

    respond_to do |format|
      format.json { render(json: :ok) }
      format.html { redirect_to assessor_form_answer_path(form_answer) }
    end
  end

  private

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
    @form_answer ||= FormAnswer.find(params[:form_answer_id])
  end
end
