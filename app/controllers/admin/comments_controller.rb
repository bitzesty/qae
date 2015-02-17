class Admin::CommentsController < Admin::BaseController
  def create
    @comment = form_answer.comments.build(create_params)
    @comment.save

    respond_to do |format|
      format.html do
        redirect_to [:admin, form_answer]
      end
    end
  end

  private

  helper_method :form_answer

  def create_params
    attrs             = params.require(:comment).permit :body
    attrs[:author_id] = current_admin.id
    attrs
  end

  def form_answer
    @form_answer ||= FormAnswer.find(params[:form_answer_id])
  end
end
