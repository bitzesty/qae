class AddAdminSignOffToPressSummaries < ActiveRecord::Migration
  def change
    add_column :press_summaries, :admin_sign_off, :boolean, default: false
  end
end
