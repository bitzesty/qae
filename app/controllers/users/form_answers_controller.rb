class Users::FormAnswersController < Users::BaseController  
  expose(:form_answer) {
    current_user.form_answers.find(params[:id])
  }

  def show
    respond_to do |format|
      format.pdf do
        pdf = form_answer.decorate.pdf_generator
        send_data pdf.render, 
                  filename: form_answer.decorate.pdf_filename,
                  type: "application/pdf"
      end
    end
  end
end
