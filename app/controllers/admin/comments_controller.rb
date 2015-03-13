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
    @comment.save

    respond_to do |format|
      format.html do
        render partial: 'admin/form_answers/comment', locals: { comment: @comment, resource: form_answer }
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
    @comment = Comment.find(params[:id])
    authorize @comment, :destroy?

    @comment.destroy

    respond_to do |format|
      format.json{ render(json: :ok)}
      format.html{ redirect_to admin_form_answer_path(form_answer)}
    end
  end

  private

  def update_params
    params.require(:comment).permit(:flagged)
  end

  def resource
    @comment ||= form_answer.comments.find(params[:id])
  end

  def create_params
    # Depends on the context - todo
    params.require(:comment).permit :body, :section, :flagged
  end

  def form_answer
    @form_answer ||= FormAnswer.find(params[:form_answer_id])
  end
end
