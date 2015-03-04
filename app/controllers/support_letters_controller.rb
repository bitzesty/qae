class SupportLettersController < ApplicationController
  before_action :load_letter_and_check_access_key

  def update
    if @support_letter.update(support_letter_params)
      redirect_to root_url, notice: 'Support letter was successfully created'
    else
      render :show
    end
  end

  private

  def load_letter_and_check_access_key
    @supporter =  Supporter.find_by_access_key(params[:access_key])

    if @supporter
      @support_letter = @supporter.support_letter || @supporter.build_support_letter(
        first_name: @supporter.first_name,
        last_name: @supporter.last_name,
        relationship_to_nominee: @supporter.relationship_to_nominee
      )
    else
      head 404
    end
  end

  def support_letter_params
    if params[:support_letter]
      params.require(:support_letter).permit(:body)
    else
      {}
    end
  end
end
