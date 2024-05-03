class FormAnswerProgress < ApplicationRecord
  belongs_to :form_answer, optional: true

  validates :form_answer_id, presence: true

  def section(number)
    return "-" if sections.blank?

    out = sections["section#{number}"]
    return "-" if out.blank?

    "#{out}%"
  end

  def assign_sections(award_form)
    doc = {}
    (0..5).each do |i|
      doc["section#{i + 1}"] = as_percentage(award_form.steps[i])
    end
    self.sections = doc
  end

  private

  def as_percentage(p)
    return nil unless p

    ((p.progress || 0) * 100).round
  end
end
