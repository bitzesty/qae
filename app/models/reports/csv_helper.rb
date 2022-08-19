require "csv"

module Reports::CSVHelper
  def build
    CSV.generate(encoding: "UTF-8", force_quotes: true) do |csv|
      csv << headers

      @scope.each do |form_answer|
        form_answer = Reports::FormAnswer.new(form_answer)

        csv << mapping.map do |m|
          sanitize_string(
            form_answer.call_method(m[:method])
          )
        end
      end
    end
  end

  def as_csv(rows)
    CSV.generate(encoding: "UTF-8", force_quotes: true) do |csv|
      csv << headers

      rows.each do |row|
        sanitized_array = row.map do |item|
          sanitize_string(item)
        end

        csv << sanitized_array
      end
    end
  end

  private

    def headers
      mapping.map { |m| m[:label] }
    end

    def sanitize_string(string)
      string.present? ? string.to_s.tr("\n","").squish : ""
    end
end
