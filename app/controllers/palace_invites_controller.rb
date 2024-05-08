class PalaceInvitesController < ApplicationController
  before_action :load_invite
  before_action :require_palace_invite_to_be_not_submitted_and_proper_stage!
  before_action :check_reception_attendee_information_deadline!

  def update
    if palace_invite_attributes.present? &&
      @invite_form.update(palace_invite_attributes.to_h.merge({submitted: params[:submit].present?}))
      log_event
      if @invite.submitted?
        flash.notice = "Windsor Castle Attendee details have been successfully submitted."
        redirect_to edit_palace_invite_url(id: @invite.token)
      else
        flash.notice = "Windsor Castle Attendee details have been successfully updated."
        redirect_to edit_palace_invite_url(id: @invite.token)
      end
    else
      render :edit
    end
  end

  private

  def load_invite
    @invite = PalaceInvite.find_by(token: params[:id]) or raise ActionController::RoutingError.new("Not Found")
    @invite_form = PalaceInviteForm.new(@invite)
  end

  def palace_invite_attributes
    if params[:palace_invite].present?
      params.require(:palace_invite).permit(
        palace_attendees_attributes: [
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
          :disabled_access,
          :dietary_requirements,
          :additional_info,
          :has_royal_family_connections,
          :royal_family_connection_details,
          :id,
          :_remove
        ],
      )
    end
  end

  def require_palace_invite_to_be_not_submitted_and_proper_stage!
    if !Settings.buckingham_palace_invites_stage?(@invite.form_answer.award_year.settings)
      flash.notice = "Access denied!"
      redirect_to dashboard_url

      return
    end
  end

  def check_reception_attendee_information_deadline!
    return if @invite.submitted?
    return unless @invite.form_answer.award_year.fetch_deadline("buckingham_palace_reception_attendee_information_due_by")&.trigger_at&.past?

    redirect_to palace_invite_expired_url(id: @invite.token)

    return
  end

  def action_type
    params[:submit] ? "palace_attendee_submit" : "palace_attendee_update"
  end

  def form_answer
    @invite.form_answer
  end
end
