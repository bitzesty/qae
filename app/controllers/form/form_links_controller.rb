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
    # self.form_link = FormLink.new(link_params)
    # form_link.valid?

    render :index
  end

  def destroy

    render :index
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
