class Judge::CaseSummariesController < Judge::BaseController
  def index
    authorize :case_summary, :index?
  end

  def download
    authorize :case_summary, :show?
    log_action "case_summaries"

    respond_to do |format|
      format.pdf do
        pdf = Reports::AdminReport.new("case_summaries", AwardYear.current, params).as_pdf
        if pdf[:hard_copy].blank? || Rails.env.development?
          send_data pdf.data,
                    filename: pdf.filename,
                    type: "application/pdf",
                    disposition: "attachment"
        else
          redirect_to pdf.data, allow_other_host: true
        end
      end
    end
  end
end
