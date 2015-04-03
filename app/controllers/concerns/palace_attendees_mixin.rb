module PalaceAttendeesMixin
  def create
    authorize form_answer, :update?

    palace_attendee = palace_invite.palace_attendees.create(create_params)
    render_attendee_form(palace_attendee)
  end

  def update
    authorize form_answer, :update?

    palace_attendee = palace_invite.palace_attendees.find(params[:id])
    palace_attendee.update(create_params)
    render_attendee_form(palace_attendee)
  end

  def destroy
    authorize form_answer, :update?
    palace_attendee = palace_invite.palace_attendees.find(params[:id])
    palace_attendee.destroy
    respond_to do |format|
      format.html { redirect_to [namespace_name, form_answer] }
      format.js { render nothing: true }
    end
  end

  private

  def render_attendee_form(palace_attendee)
    respond_to do |format|
      format.html do
        if request.xhr?
          render(
            partial: "admin/form_answers/winners_components/palace_attendee_form",
            locals: { palace_attendee: palace_attendee })
        else
          redirect_to [namespace_name, form_answer]
        end
      end
    end
  end

  def palace_invite
    @palace_invite ||= PalaceInvite.find(create_params[:palace_invite_id])
  end

  def form_answer
    @form_answer ||= palace_invite.form_answer
  end

  def create_params
    params.require(:palace_attendee).permit(
      :title,
      :first_name,
      :last_name,
      :job_name,
      :post_nominals,
      :address_1,
      :address_2,
      :address_3,
      :address_4,
      :postcode,
      :phone_number,
      :product_description,
      :additional_info,
      :palace_invite_id,
      :id
    )
  end
end
