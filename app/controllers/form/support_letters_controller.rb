class Form::SupportLettersController < Form::BaseController
  before_action :load_letter, only: :destroy

  def create
    @support_letter = @form_answer.support_letters.new(
      support_letter_params.merge(
        user_id: current_user.id,
        manual: true,
      ),
    )

    attachment = SupportLetterAttachment.new(attachment_params)
    attachment.user = current_user
    attachment.form_answer = @form_answer
    attachment.original_filename = attachment_params[:attachment].try(:original_filename)
    @support_letter.support_letter_attachment = attachment

    if @support_letter.save
      add_support_letter_to_document!
      @form_answer.save

      redirect_to form_form_answer_supporters_path(@form_answer)
    else
      render :new
    end
  end

  def new
    @support_letter = @form_answer.support_letters.new
  end

  def destroy
    if @support_letter.destroy
      remove_support_letter_from_document!
      @form_answer.save
    end

    redirect_to form_form_answer_supporters_path(@form_answer)
  end

  private

  def support_letter_params
    params[:support_letter].permit(
      :first_name,
      :last_name,
      :relationship_to_nominee,
    )
  end

  def attachment_params
    if params[:support_letter] && params[:support_letter][:support_letter_attachment]
      params[:support_letter][:support_letter_attachment].permit(:attachment)
    else
      {}
    end
  end

  def load_letter
    @support_letter = @form_answer.support_letters.find(params[:id])
  end

  def add_support_letter_to_document!
    letters = support_letters_doc

    new_letter = {
      support_letter_id: @support_letter.id,
      first_name: @support_letter.first_name,
      last_name: @support_letter.last_name,
      relationship_to_nominee: @support_letter.relationship_to_nominee,
      letter_of_support: @support_letter.support_letter_attachment.id,
    }

    letters << new_letter

    @form_answer.document = @form_answer.document.merge(supporter_letters_list: letters,
      manually_upload: "yes",)
  end

  def remove_support_letter_from_document!
    letters = support_letters_doc

    letters.delete_if do |sup|
      sup["support_letter_id"] == @support_letter.id
    end

    @form_answer.document = @form_answer.document.merge(supporter_letters_list: letters)
  end

  def support_letters_doc
    if @form_answer.document["supporter_letters_list"].present?
      @form_answer.document["supporter_letters_list"]
    else
      []
    end
  end
end
