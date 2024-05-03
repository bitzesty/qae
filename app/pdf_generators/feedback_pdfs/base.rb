class FeedbackPdfs::Base < ReportPdfBase
  attr_reader :feedbacks

  def all_mode
    set_feedbacks
    if feedbacks.present?
      feedbacks.each_with_index do |feedback, index|
        start_new_page if index.to_i != 0
        render_item(feedback.form_answer)
      end
    else
      @missing_data_name = "feedbacks"
      render_not_found_block
    end
  end

  def set_feedbacks
    @feedbacks = Feedback.submitted
                         .includes(:form_answer)
                         .joins(form_answer: :award_year)
                         .where(form_answers: { award_type: options[:category] })
                         .where(form_answers: { award_year_id: award_year.id })
  end

  def render_item(form_answer)
    FeedbackPdfs::Pointer.new(self, form_answer)
  end
end
