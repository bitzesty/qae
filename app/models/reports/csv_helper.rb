require "csv"

module Reports::CSVHelper
  def build
    csv_string = CSV.generate do |csv|
      csv << headers
      @scope.each do |form_answer|
        form_answer = Reports::FormAnswer.new(form_answer)
        csv << mapping.map do |m|
          form_answer.call_method(m[:method])
        end
      end
    end

    csv_string
  end

  private

  def headers
    mapping.map { |m| m[:label] }
  end
end
