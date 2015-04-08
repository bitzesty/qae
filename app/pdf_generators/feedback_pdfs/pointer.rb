class FeedbackPdfs::Pointer < ReportPdfFormAnswerPointerBase
  include FeedbackPdfs::General::DrawElements
  include FeedbackPdfs::General::DataPointer

  attr_reader :data

  def generate!
    @data = form_answer.feedback.document
    main_header
    render_data!
  end
end
