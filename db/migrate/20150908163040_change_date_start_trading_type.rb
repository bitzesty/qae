class ChangeDateStartTradingType < ActiveRecord::Migration
  def up
    remove_column :company_details, :date_started_trading, :string
    add_column    :company_details, :date_started_trading, :datetime
  end

  def down
    remove_column :company_details, :date_started_trading, :datetime
    add_column    :company_details, :date_started_trading, :string
  end
end
