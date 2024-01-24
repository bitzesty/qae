module PalaceInvitesMixin
  def submit
    @invite = PalaceInvite.find(params[:id])
    authorize @invite, :update?

    @invite.submit!

    respond_to do |format|
      format.js { render "admin/form_answers/winners_components/palace_invite_submitted" }
      format.html do
        redirect_to [namespace_name, @invite.form_answer]
      end
    end
  end
end
