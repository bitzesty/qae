class AuditCertificateCsvGenerator
  attr_reader :audit_data, :form_answer

  def initialize(form_answer)
    @form_answer = form_answer.decorate
    @audit_data = FormFinancialPointer.new(form_answer).data
  end

  def run
    CSV.generate do |csv|
      csv << csv_general_headers

      audit_data.each do |question_block|
        question_key = question_block.keys.first.to_s
        question_data = question_block.values.first

        csv << (csv_section_header(question_key) + csv_data(question_data))
      end

      csv
    end
  end

  def csv_general_headers
    [
      form_answer.award_application_title,
      form_answer.company_or_nominee_name
    ]
  end

  def csv_section_header(question_key)
    [QuestionLabels::AuditCertificateLabel.find(question_key).label]
  end

  def csv_data(question_data)
    question_data.map do |entry|
      if entry.is_a?(Array)
        entry.join("/")
      else
        entry[:value]
      end
    end
  end
end
