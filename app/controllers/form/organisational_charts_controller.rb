class Form::OrganisationalChartsController < Form::MaterialsBaseController

  # This controller handles saving of OrganisationalCharts attachments
  # This section is used in case if JS disabled

  expose(:form_answer_attachments) do
    @form_answer.form_answer_attachments
  end

  expose(:form_answer_attachment) do
    current_user.form_answer_attachments.new(
      form_answer_id: @form_answer.id
    )
  end

  expose(:original_filename) do
    attachment_params[:file].present? ? attachment_params[:file].original_filename : nil
  end

  expose(:existing_org_chart_doc) do
    @form_answer.document["org_chart"]
  end

  expose(:existing_org_chart) do
    if existing_org_chart_doc.present?
      existing_org_chart_doc
    else
      {}
    end
  end

  expose(:created_attachment_ops) do
    {
      "file" => form_answer_attachment.id.to_s
    }
  end

  expose(:add_org_chart_result_doc) do
    res = existing_org_chart
    res["0"] = created_attachment_ops

    @form_answer.document.merge(
      org_chart: res
    )
  end

  expose(:remove_org_chart_result_doc) do
    @form_answer.document.merge(
      org_chart: {}
    )
  end

  def new
  end

  def create
    self.form_answer_attachment = current_user.form_answer_attachments.new(
      attachment_params.merge({
        form_answer_id: @form_answer.id,
        original_filename: original_filename,
        question_key: "org_chart"
      })
    )

    if form_answer_attachment.save
      @form_answer.document = add_org_chart_result_doc
      @form_answer.save

      redirect_to edit_form_url(id: @form_answer.id, step: "company-information", anchor: anchor)
    else
      render :new
    end
  end

  def confirm_deletion
    self.form_answer_attachment = form_answer_attachments.find(params[:organisational_chart_id])
  end

  def destroy
    self.form_answer_attachment = form_answer_attachments.find(params[:id])
    @form_answer.document = remove_org_chart_result_doc

    if @form_answer.save
      form_answer_attachment.destroy
    end

    respond_to do |format|
      format.html do
        if request.xhr? || request.format.js?
          head :ok
        else
          redirect_to edit_form_url(id: @form_answer.id, step: "company-information", anchor: anchor)
        end
      end
    end
  end

  private

    def attachment_params
      params.require(:form_answer_attachment).permit(
        :file,
        :form_answer_id
      )
    end
end
