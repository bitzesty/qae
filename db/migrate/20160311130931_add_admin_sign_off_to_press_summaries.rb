class AddAdminSignOffToPressSummaries < ActiveRecord::Migration[4.2]
  def change
    add_column :press_summaries, :admin_sign_off, :boolean, default: false
  end
end
