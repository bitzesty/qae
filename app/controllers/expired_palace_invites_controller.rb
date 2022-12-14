class ExpiredPalaceInvitesController < ApplicationController
  def show
    @invite = PalaceInvite.find_by(token: params[:id]) or raise ActionController::RoutingError.new("Not Found")
  end
end
