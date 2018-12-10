class AddFinancialDataToFormAnswers < ActiveRecord::Migration[4.2]
  def change
    add_column :form_answers, :financial_data, :hstore
  end
end
