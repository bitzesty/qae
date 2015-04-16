class Users::FormAttachmentsAndLinksController < Users::BaseController

  # This controller handles saving of attachments and website links
  # This section is used in case if JS disabled

  expose(:form_answer) do
    current_user.account.
                form_answers.
                find(params[:form_answer_id])
  end

  def index
  end

  def create
  end

  def destroy
  end

  private

    def form_attachment_params
      params.require(:support_letter).permit(
        :first_name,
        :last_name,
        :relationship_to_nominee,
        :email
      )
    end
end
