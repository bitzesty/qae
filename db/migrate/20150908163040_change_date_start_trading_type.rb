class ChangeDateStartTradingType < ActiveRecord::Migration[4.2]
  def up
    remove_column :company_details, :date_started_trading, :string
    add_column    :company_details, :date_started_trading, :datetime
  end

  def down
    remove_column :company_details, :date_started_trading, :datetime
    add_column    :company_details, :date_started_trading, :string
  end
end
