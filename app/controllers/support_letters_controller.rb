class SupportLettersController < ApplicationController
  before_action :load_letter_and_check_access_key

  expose(:supporter) do
    Supporter.find_by(access_key: params[:access_key])
  end

  expose(:support_letter) do
    supporter.support_letter ||
      supporter.build_support_letter(
        first_name: supporter.first_name,
        last_name: supporter.last_name,
        relationship_to_nominee: supporter.relationship_to_nominee,
        form_answer: supporter.form_answer,
        user: supporter.user,
      )
  end

  def create
    if support_letter.update(support_letter_params)
      redirect_to support_letter_path(access_key: supporter.access_key),
                  notice: "Support letter was successfully created"
    else
      render :new
    end
  end

  private

  def load_letter_and_check_access_key
    if supporter
      if supporter.support_letter && supporter.support_letter.persisted? && action_name != "show"
        redirect_to support_letter_path(access_key: supporter.access_key),
                    notice: "Support Letter has been submitted already!"
        nil
      end
    else
      head 404
    end
  end

  def support_letter_params
    if params[:support_letter]
      params.require(:support_letter).permit(
        :first_name,
        :last_name,
        :organization_name,
        :phone,
        :relationship_to_nominee,
        :address_first,
        :address_second,
        :city,
        :country,
        :postcode,
        :body,
      )
    else
      {}
    end
  end
end
