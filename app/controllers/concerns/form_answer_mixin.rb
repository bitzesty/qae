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

      format.html { redirect_to [namespace_name, resource] }
    end
  end

  private

  def update_params
    params.require(:form_answer).permit(:sic_code)
  end
end
