class PalaceInvitesController < ApplicationController
  before_action :load_invite

  def update
    if @invite_form.update(palace_invite_attributes)
      flash.notice = "Attendee details have been successfully updated"
      redirect_to edit_palace_invite_path(id: @invite_form.invite.token)
    else
      render :edit
    end
  end

  private

  def load_invite
    palace_invite = PalaceInvite.find_by_token(params[:id])
    @invite_form = PalaceInviteForm.new(palace_invite)
  end

  def palace_invite_attributes
    params.require(:palace_invite).permit(
      palace_attendees_attributes:
        [:title,
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
         :id,
         :_remove]
    )
  end
end
