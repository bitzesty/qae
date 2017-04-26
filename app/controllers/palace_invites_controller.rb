class PalaceInvitesController < ApplicationController
  before_action :load_invite
  before_action :require_palace_invite_to_be_not_submitted_and_proper_stage!

  def update
    if palace_invite_attributes.present? &&
      @invite_form.update(palace_invite_attributes.merge({submitted: params[:submit].present?}))

      if @invite.submitted?
        flash.notice = "Palace Attendees details are successfully submitted!"
        redirect_to edit_palace_invite_url(id: @invite.token)
      else
        flash.notice = "Attendee details have been successfully updated"
        redirect_to edit_palace_invite_url(id: @invite.token)
      end
    else
      render :edit
    end
  end

  private

  def load_invite
    @invite = PalaceInvite.find_by_token(params[:id]) or raise ActionController::RoutingError.new("Not Found")
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
          :additional_info,
          :id,
          :_remove
        ]
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
end
