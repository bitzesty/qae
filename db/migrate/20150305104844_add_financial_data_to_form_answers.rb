class AddFinancialDataToFormAnswers < ActiveRecord::Migration
  def change
    add_column :form_answers, :financial_data, :hstore
  end
end
