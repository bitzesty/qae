class Form::FormLinksController < Form::MaterialsBaseController

  # This controller handles saving of website links
  # This section is used in case if JS disabled

  expose(:form_link) do
    FormLink.new
  end

  def new
  end

  def create
    Rails.logger.info "[link_params] #{link_params}"
    self.form_link = FormLink.new(link_params)

    if form_link.valid?
      # save to form_answer
      redirect_to form_form_answer_form_attachments_url
    else
      render :new
    end
  end

  def destroy


    redirect_to form_form_answer_form_attachments_url
  end

  private
    def link_params
      params.require(:form_link).permit(
        :link,
        :position,
        :description
      )
    end
end
