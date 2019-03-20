class Admin::ReportsController < Admin::BaseController

  expose(:import_csv_pdf_guide) do
    File.open("#{Rails.root}/lib/assets/IMPORT_CSV_INTO_MS_EXCEL_GUIDE.pdf")
  end

  def show
    authorize :report, :show?
    log_action params[:id]

    respond_to do |format|
      format.html

      format.csv do
        send_data resource.as_csv, type: "text/csv", disposition: 'attachment'
      end

      format.pdf do
        pdf = resource.as_pdf

        if pdf[:hard_copy].blank? || Rails.env.development?
          send_data pdf.data,
                    filename: pdf.filename,
                    type: "application/pdf",
                    disposition: 'attachment'
        else
          redirect_to pdf.data
        end
      end
    end
  end

  def import_csv_into_ms_excel_guide_pdf
    authorize :report, :show?

    send_data import_csv_pdf_guide.read,
              type: "application/pdf",
              disposition: 'inline'
  end

  private

  def resource
    @report ||= Reports::AdminReport.new(params[:id], @award_year, params)
  end
end
