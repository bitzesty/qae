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
        stream_csv
      end

      format.xlsx do
        send_data resource.as_xlsx.stream.string,
                  type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                  disposition: 'attachment'
      end

      format.pdf do
        pdf = resource.as_pdf

        if pdf[:hard_copy].blank? || Rails.env.development?
          send_data pdf.data,
                    filename: pdf.filename,
                    type: "application/pdf",
                    disposition: 'attachment'
        else
          redirect_to pdf.data, allow_other_host: true
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

  def stream_csv
    headers["Content-Type"] = "text/csv; charset=utf-8" # In Rails 5 it's set to HTML??
    headers["Content-Disposition"] = %{attachment; filename="#{csv_filename}"}

    headers["X-Accel-Buffering"] = "no"
    headers["Cache-Control"] = "no-cache"
    headers["Last-Modified"] = Time.current.httpdate

    self.response_body = resource.as_csv

    response.status = 200
  end

  def csv_filename
    resource.csv_filename.presence || "#{params[:id] || "report"}.csv"
  end

  def resource
    @report ||= Reports::AdminReport.new(params[:id], @award_year, params)
  end
end
