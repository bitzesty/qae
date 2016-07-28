class RemoveSicCodeFromFormAnswers < ActiveRecord::Migration
  def change
    forms = AwardYear.first.form_answers.where.not(sic_code: nil)

    forms.each do |form|
      form.document["sic_code"] = form.sic_code
      form.save!(validate: false)
    end

    remove_column :form_answers, :sic_code, :string
  end
end
