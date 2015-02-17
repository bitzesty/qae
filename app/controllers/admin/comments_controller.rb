class Admin::CommentsController < Admin::BaseController
  def new
    @comment = form_answer.comments.build

    respond_to do |format|
      format.html{ render :new, layout: false}
    end
  end

  def create
    @comment = form_answer.comments.build(create_params)
    @comment.save

    respond_to do |format|
      format.html do
        render partial: 'admin/form_answers/comment', locals: { comment: @comment, resource: form_answer }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.author?(current_admin)
      @comment.destroy
    end

    respond_to do |format|
      format.json{ render(json: :ok)}
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
