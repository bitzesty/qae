module FormAnswerMixin
  def update
    authorize resource, :update?
    resource.update(update_params)
    respond_to do |format|
      format.json do
        render json: {
          form_answer: {
            sic_codes: resource.decorate.all_average_growths,
            legend: resource.decorate.average_growth_legend
          }
        }
      end

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
    params.require(:form_answer).permit(
      :sic_code,
      previous_wins_attributes: [:id, :year, :category, :_destroy]
    )
  end
end
