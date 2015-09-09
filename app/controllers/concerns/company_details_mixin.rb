module CompanyDetailsMixin
  ADDRESS_FIELDS = [
    :address_building,
    :address_street,
    :address_city,
    :address_county,
    :address_postcode,
    :telephone,
    :region,
    :nominee_title,
    :nominee_organisation,
    :nominee_position,
    :nominee_organisation_website,
    :nominee_building,
    :nominee_street,
    :nominee_city,
    :nominee_county,
    :nominee_postcode,
    :nominee_telephone,
    :nominee_email,
    :nominee_region,
    :nominator_name,
    :nominator_building,
    :nominator_street,
    :nominator_city,
    :nominator_county,
    :nominator_postcode,
    :nominator_telephone,
    :nominator_email
  ]

  COMPANY_DETAILS_FIELDS = ADDRESS_FIELDS + [
    :registration_number,
    :date_started_trading,
    :website_url,
    :head_of_bussines_title,
    :head_of_business_full_name,
    :head_of_business_honours,
    :head_job_title,
    :head_email,
    :applying_for,
    :parent_company,
    :parent_company_country,
    :parent_ultimate_control,
    :ultimate_control_company,
    :ultimate_control_company_country,
    :innovation_desc_short,
    :development_desc_short,
    trade_goods_descriptions: []
  ]

  def update
    # TODO add section=address hidden fields and delete the following line
    params[:section] = "address" unless params[:section]

    @company_detail = CompanyDetail.find(params[:id])
    authorize @company_detail, :update?

    @company_detail.update(allowed_params)
    @form_answer = @company_detail.form_answer.decorate
    @form_answer.company_details_updated_at = DateTime.now
    @form_answer.company_details_editable = current_subject
    @form_answer.save

    respond_to do |format|
      format.html do
        if request.xhr?
          render partial: "admin/form_answers/company_details/#{params[:section]}_form", layout: false
        else
          redirect_to [namespace_name, resource]
        end
      end
    end
  end

  private

  def update_params
    params.require(:company_detail).permit COMPANY_DETAILS_FIELDS
  end

  def allowed_params
    ops = update_params

    ops.reject! do |k, v|
      ADDRESS_FIELDS.include?(k.to_sym) &&
      !CompanyDetailPolicy.new(pundit_user, resource).can_manage_address?
    end

    ops
  end

  def resource
    @form_answer ||= @company_detail.form_answer
  end
end
