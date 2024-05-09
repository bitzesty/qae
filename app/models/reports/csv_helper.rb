require "csv"

module Reports::CsvHelper
  def build
    CSV.generate(encoding: "UTF-8", force_quotes: true) do |csv|
      csv << headers

      @scope.each do |form_answer|
        form_answer = Reports::FormAnswer.new(form_answer)

        csv << mapping.map do |m|
          sanitize_string(
            form_answer.call_method(m[:method]),
          )
        end
      end
    end
  end

  def prepare_response(scope, limited_access = false, builder = nil)
    CSV.generate(encoding: "UTF-8", force_quotes: true) do |csv|
      csv << headers

      scope.find_each do |fa|
        f = if builder.nil?
          Reports::FormAnswer.new(fa, limited_access)
        else
          builder.new(fa)
        end

        csv << mapping.map do |m|
          raw = f.call_method(m[:method])
          Utils::String.sanitize(raw)
        end
      end
    end
  end

  def prepare_stream(scope, limited_access = false)
    @_csv_enumerator ||= Enumerator.new do |yielder|
      yielder << CSV.generate_line(headers, encoding: "UTF-8", force_quotes: true)

      scope.find_each do |fa|
        f = Reports::FormAnswer.new(fa, limited_access)

        row = mapping.map do |m|
          raw = f.call_method(m[:method])
          Utils::String.sanitize(raw)
        end

        yielder << CSV.generate_line(row, encoding: "UTF-8", force_quotes: true)
      end
    end
  end

  private

  def headers
    mapping.map { |m| m[:label] }
  end

  def sanitize_string(string)
    string.present? ? string.to_s.tr("\n", "").squish : ""
  end
end
